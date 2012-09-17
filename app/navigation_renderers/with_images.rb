# Renders an ItemContainer as a <ul> element and its containing items as <li> elements.
    # It adds the 'selected' class to li element AND the link inside the li element that is currently active.
    #
    # If the sub navigation should be included (based on the level and expand_all options), it renders another <ul> containing the sub navigation inside the active <li> element.
    #
    # By default, the renderer sets the item's key as dom_id for the rendered <li> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
    # The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
    class WithImages < SimpleNavigation::Renderer::Base
      def render(item_container)
        list_content = item_container.items.inject([]) do |list, item|
          image_url = item.html_options[:image]
          li_options = item.html_options.reject {|k, v| k == :link}
          li_options = item.html_options.reject {|k, v| k == :image}

          if image_url
            li_image = image_tag(image_url,item.name)
            li_content = tag_for(item,li_image)
          else
            li_content = tag_for(item,nil)
          end


          if include_sub_navigation?(item)
            li_content << render_sub_navigation_for(item)
          end
          list << content_tag(:li, li_content, li_options)
        end.join
        if skip_if_empty? && item_container.empty?
          ''
        else
          content_tag((options[:ordered] ? :ol : :ul), list_content, {:id => item_container.dom_id, :class => item_container.dom_class})
        end
      end
      def image_tag(url,title)
        image = "<img src='#{url}' title='#{title}' />"
      end
      def tag_for(item,image)
        if image.nil?
          if item.url.nil?
            content_tag('span', item.name, link_options_for(item).except(:method))
          else
            link_to(item.name, item.url, link_options_for(item))
          end
        else
          if item.url.nil?
            image + item.name
          else
            link_to(image + content_tag(:span,item.name), item.url, link_options_for(item))
          end
        end

      end
    end