require 'rails_helper'

RSpec.describe Product, :type => :model do
  it "is invalid without name" do
    product = Product.new({:name => nil})
    expect(product).to be_invalid
    expect(product.errors.include?(:name)).to be_truthy
    expect(product.errors[:name].include?("can't be blank")).to be_truthy

  end

  it "is invalid with a duplicate name" do
    Product.create!({:name => 'Test'})
    product = Product.new({:name => 'Test'})
    expect(product).to be_invalid
    expect(product.errors.include?(:name)).to be_truthy
    expect(product.errors[:name].include?("has already been taken")).to be_truthy
  end


  it "assign categories with categories_tags setter" do
    (1..5).each{|n| Category.create({:name => "Category_#{n}"})}
    product = Product.create!({:name => 'Test'})
    assert_empty(product.categories)
    expect(product.categories_tags).to eql(product.categories.map(&:id).join(','))
    product.categories_tags = Category.all.map(&:id).join(',')
    expect(product.categories_tags).to eql(product.categories.map(&:id).join(','))
    expect(product.categories.count).to be(Category.count)
  end
end
