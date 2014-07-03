require 'rails_helper'

RSpec.describe "products/index", :type => :view do
  before do
    Product.create!(
        :name => "Name1",
        :price => 1.5
    )

    Product.create!(
        :name => "Name2",
        :price => 1.5
    )
  end

  it "renders a list of products" do
    visit products_path
    assert_selector('tr#1', :count => 1)
    assert_selector('tr#2', :count => 1)

  end
end
