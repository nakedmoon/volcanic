module ApplicationHelper


  def nav_link(nav)
    begin
      member_route = nav.to_s.singularize
      collection_route = nav.to_s.pluralize
      model = member_route.camelize.constantize
      label = model.send(:nav_label) rescue collection_route
      url = eval("#{collection_route}_path")
      active_paths = []
      active_paths << /\/*#{member_route}\/*/
      active_paths << /\/*#{collection_route}\/*/
      active = false
      active_paths.each do |path|
        active = !controller_path.match(path).nil?
        break if active
      end
      content_tag(:li, link_to(label, url), :class => active ? 'active' : '')
    rescue NameError
      raise
    rescue NoMethodError
      raise
    end

  end
end
