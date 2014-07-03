json.array!(@categories) do |category|
  json.set! :id, category.id.to_s
  #json.set! :children, category.has_children?
  json.set! :parent, category.parent_id || '#'
  json.set! :text, category.name
  json.set! :type, category.is_root? ? 'folder' : (category.has_children? ? 'subfolder' : 'file')
  json.set! :data, {
      :crud => {
          :edit => {:url => edit_category_path(category), :method => :get},
          :new => {:url => new_category_path(:parent_id => category), :method => :get},
          :delete => {:url => category_path(category), :method => :delete},
          :move => {:url => move_category_path(category), :method => :post}
      }
  }
end



