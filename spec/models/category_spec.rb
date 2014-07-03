require 'rails_helper'

RSpec.describe Category, :type => :model do

  it "is invalid without name" do
    category = Category.new({:name => nil})
    expect(category).to be_invalid
    expect(category.errors.include?(:name)).to be_truthy
    expect(category.errors[:name].include?("can't be blank")).to be_truthy

  end

  it "is invalid with a duplicate name" do
    Category.create!({:name => 'Test'})
    category = Category.new({:name => 'Test'})
    expect(category).to be_invalid
    expect(category.errors.include?(:name)).to be_truthy
    expect(category.errors[:name].include?("has already been taken")).to be_truthy
  end

end
