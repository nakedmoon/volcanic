require 'rails_helper'


RSpec.describe "categories/index", :type => :view do
  before do

    index = 0
    10.times do
      index +=1
      category = Category.create!(:name => "News_#{format('%02d', index )}")
    end
    @categories = Category.all
  end




  it "renders a list of categories", :js => true, :driver => :selenium do
    visit categories_path
    category_tree = find_by_id('categories-tree')
    category_tree.assert_selector('li', :count => 10)
    @categories.each do |category|
      node = category_tree.find_by_id(category.id)
      expect(node).to_not be_nil
      node_link = node.find('a')
      expect(node_link).to_not be_nil
      expect(node_link.text).to eq(category.name)
    end
    parent_category = Category.find(10)
    sub_category = Category.create!(:name => "SubCatOf_#{parent_category.id}", :parent => parent_category)
    visit categories_path
    category_tree = find_by_id('categories-tree') # reload container
    node = category_tree.find_by_id(parent_category.id) # get the parent dom
    node_anchor = node.first('.jstree-ocl') # get the parent anchor
    node_anchor.click # expand node
    sub_node = node.find_by_id(sub_category.id) # check for subnode
    sub_node_link = sub_node.find('a')
    expect(sub_node_link).to_not be_nil
    expect(sub_node_link.text).to eq(sub_category.name)


  end

  it "search  a list of categories", :js => true, :driver => :selenium do
    visit categories_path
    fill_in('tree-search', :with => 'News_01')
    category_tree = find_by_id('categories-tree')
    expected_category = Category.find_by_name('News_01')
    expected_node = category_tree.find_by_id(expected_category.id)
    expected_node_link = expected_node.find('a')
    expect(expected_node_link[:class].include?('jstree-search')).to be_truthy # hovered search result
  end

  it "add root category", :js => true, :driver => :selenium do
    visit categories_path
    find_by_id('category-modal', :visible => false)
    click_link_or_button('tree-action-new')
    modal = find_by_id('category-modal', :visible => true)
    expect(modal.visible?).to be_truthy
    modal_body = modal.find('div.modal-body')
    modal_footer = modal.find('div.modal-footer')
    form = modal_body.find('form#new_category')
    form.fill_in('category[name]', :with => 'News_11')
    modal_footer.find('button.ajax-submit').click
    category_tree = find_by_id('categories-tree')
    category_tree.assert_selector('li', :count => 11)
    new_category = Category.find_by_name('News_11')
    new_node = category_tree.find_by_id(new_category.id)
    new_node_link = new_node.find('a')
    expect(new_node_link.text).to eq(new_category.name)
  end

  it "delete category", :js => true, :driver => :selenium do
    visit categories_path
    category_tree = find_by_id('categories-tree')
    delete_category = Category.find_by_name('News_10')
    delete_node = category_tree.find_by_id(delete_category.id)
    delete_node_link = delete_node.find('a')
    #context_menu = find('ul.jstree-contextmenu', :visible => false)
    delete_node_link.right_click
    context_menu = find('ul.jstree-contextmenu', :visible => true)
    delete_link = context_menu.find("a[rel='2']")
    delete_link.click
    page.driver.browser.switch_to.alert.accept
    category_tree = find_by_id('categories-tree')
    category_tree.assert_selector('li', :count => 9)
  end

  it "edit category", :js => true, :driver => :selenium do
    visit categories_path
    category_tree = find_by_id('categories-tree')
    edit_category = Category.find_by_name('News_10')
    find_by_id('category-modal', :visible => false)
    node = category_tree.find_by_id(edit_category.id)
    node_link = node.find('a')
    node_link.right_click
    context_menu = find('ul.jstree-contextmenu', :visible => true)
    edit_link = context_menu.find("a[rel='1']")
    edit_link.click
    modal = find_by_id('category-modal', :visible => true)
    expect(modal.visible?).to be_truthy
    modal_body = modal.find('div.modal-body')
    modal_footer = modal.find('div.modal-footer')
    form = modal_body.find("form#edit_category_#{edit_category.id}")
    form.fill_in('category[name]', :with => 'News_10_Edited')
    modal_footer.find('button.ajax-submit').click
    category_tree = find_by_id('categories-tree')
    category_tree.assert_selector('li', :count => 10)
    edit_node = category_tree.find_by_id(edit_category.id)
    edit_node_link = edit_node.find('a')
    expect(edit_node_link.text).to eq('News_10_Edited')

  end


end







