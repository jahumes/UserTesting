# Renders an ItemContainer as a <ul> element and its containing items as <li> elements.
# It adds the 'selected' class to li element AND the link inside the li element that is currently active.
#
# If the sub navigation should be included (based on the level and expand_all options), it renders another <ul> containing the sub navigation inside the active <li> element.
#
# By default, the renderer sets the item's key as dom_id for the rendered <li> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
# The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
class CustomBreadcrumbs < SimpleNavigation::Renderer::Base
  def render(item_container)

    list_content = content_tag(:li, content_tag(:i, nil, :class => 'icon-home') + 'Sebo Marketing' + content_tag(:span,'&raquo;',:class => 'divider')) << li_tags(item_container).join.html_safe
    d { list_content }
    if skip_if_empty? && item_container.empty?
      ''
    else
      content_tag((options[:ordered] ? :ol : :ul), list_content, {:id => container_id(item_container), :class => container_class(item_container)})
    end

  end

  def li_tags(item_container)

    item_container.items.inject([]) do |list, item|

      if item.selected?

        icon = item.html_options[:icon]
        li_options = item.html_options.reject {|k, v| k == :link || k == :image || k == :icon}

        li_content = tag_for(item,nil)



        if include_sub_navigation?(item)
          li_content << content_tag(:span,'&raquo',:class => 'divider')
          list << content_tag(:li, li_content, li_options)
          list.concat li_tags(item.sub_navigation)
        else
          list << content_tag(:li, li_content, li_options)
        end
      end
      list
    end
  end

  def image_tag(url,title)
    image = "<img src='#{url}' title='#{title}' />"
  end
  def container_class(item_container)
    if options[:class]
      if !item_container.dom_class.nil?
        options[:class]
      else
        options[:class]
      end
    else
      item_container.dom_class
    end
  end
  def container_id(item_container)
    options[:id] ? options[:id] : item_container.dom_id
  end
  def tag_for(item,icon=nil)
    if item.url.nil?
      content_tag('span', item.name, link_options_for(item).except(:method, :icon, :image))
    else
      link_to(item.name, item.url, link_options_for(item).except(:method, :icon, :image))
    end
  end
  def link_options_for(item)
    if options[:allow_classes_and_ids]
      opts = super
      opts[:id] = "breadcrumb_#{opts[:id]}" if opts[:id]
      opts
    else
      {:method => item.method}.merge(item.html_options.except(:class,:id))
    end
  end
end