# Renders an ItemContainer as a <ul> element and its containing items as <li> elements.
# It adds the 'selected' class to li element AND the link inside the li element that is currently active.
#
# If the sub navigation should be included (based on the level and expand_all options), it renders another <ul> containing the sub navigation inside the active <li> element.
#
# By default, the renderer sets the item's key as dom_id for the rendered <li> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
# The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
class CustomBreadcrumbs < SimpleNavigation::Renderer::Base
  def render(item_container)
    if !options[:sub]
      list_content = li_tags(item_container).join
      if skip_if_empty? && item_container.empty?
        ''
      else
        content_tag((options[:ordered] ? :ol : :ul), list_content, {:id => container_id(item_container), :class => container_class(item_container)})
      end
    else
      list_content = li_tags_sub(item_container).join
      if skip_if_empty? && item_container.empty?
        ''
      else
        content_tag((options[:ordered] ? :ol : :ul), list_content)
      end
    end

  end

  def li_tags(item_container)
    i = 0
    item_container.items.inject([]) do |list, item|
      if item.name == 'Dashboard' || item.selected?
        icon = item.html_options[:icon]
        li_options = item.html_options.reject {|k, v| k == :link || k == :image || k == :icon}

        if icon
          li_icon = content_tag :span, nil, :class => icon
          li_content = tag_for(item,li_icon)
        else
          li_content = tag_for(item,nil)
        end

        if include_sub_navigation?(item)
          li_content << render_sub_navigation_for(item)
        end

        list << content_tag(:li, li_content, li_options) if item.name == 'Dashboard' || item.selected?

        if include_sub_navigation?(item)
          list.concat li_tags(item.sub_navigation)
        end
      end
      list
    end
  end

  def li_tags_sub(item_container)
    item_container.items.inject([]) do |list, item|
      icon = item.html_options[:icon]
      li_options = item.html_options.reject {|k, v| k == :link || k == :image || k == :icon}

      if icon
        li_icon = content_tag :span, nil, :class => icon
        li_content = tag_for(item,li_icon)
      else
        li_content = tag_for(item,nil)
      end

      list << content_tag(:li, li_content, li_options)
    end
  end

  def render_sub_navigation_for(item)
    self.options[:sub] = true
    item.sub_navigation.render(self.options)
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
    if !icon.nil?
      if item.url.nil?
        icon + item.name
      else
        link_to(icon + item.name, item.url, link_options_for(item).except(:method, :icon, :image))
      end
    else
      if item.url.nil?
        content_tag('span', item.name, link_options_for(item).except(:method, :icon, :image))
      else
        link_to(item.name, item.url, link_options_for(item).except(:method, :icon, :image))
      end
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