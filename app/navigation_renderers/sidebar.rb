# Renders an ItemContainer as a <ul> element and its containing items as <li> elements.
# It adds the 'selected' class to li element AND the link inside the li element that is currently active.
#
# If the sub navigation should be included (based on the level and expand_all options), it renders another <ul> containing the sub navigation inside the active <li> element.
#
# By default, the renderer sets the item's key as dom_id for the rendered <li> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
# The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
class Sidebar < SimpleNavigation::Renderer::Base
  def render(item_container)
    list_content = item_container.items.inject([]) do |list, item|

      level = item_container.level
      item_container.dom_class = 'inner-nav' if level != 1

      image_url = item.html_options[:image]
      icon = item.html_options[:icon]
      li_options = item.html_options.reject {|k, v| k == :link || k == :icon}

      if icon
        li_icon = content_tag :i, nil, :class => icon
        li_content = tag_for(item,level,li_icon)
      else
        li_content = tag_for(item,level,nil)
      end

      if include_sub_navigation?(item)
        li_content << render_sub_navigation_for(item)
      end

      list << content_tag(:li, li_content, li_options)

    end.join
    if skip_if_empty? && item_container.empty?
      ''
    else
      content_tag((options[:ordered] ? :ol : :ul), list_content, {:id => container_id(item_container), :class => container_class(item_container)})
    end
  end

  def render_sub_navigation_for(item)
    item.sub_navigation.render(self.options)
  end

  def image_tag(url,title)
    image = "<img src='#{url}' title='#{title}' />"
  end
  def container_class(item_container)
    if options[:class]
      if !item_container.dom_class.nil?
        options[:class] + " " + item_container.dom_class
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
  def tag_for(item,level=1,icon=nil)
    if level == 1 && !icon.nil?
      content_tag('span', icon + content_tag(:span, item.name, :class => 'nav-title'),:title => item.name)
    else
      if !icon.nil?
        if item.url.nil?
          icon + item.name
        else
          link_to(icon + item.name, item.url, link_options_for(item))
        end
      else
        if item.url.nil?
          content_tag('span', item.name, link_options_for(item).except(:method))
        else
          link_to(item.name, item.url, link_options_for(item))
        end
      end
    end
  end
end