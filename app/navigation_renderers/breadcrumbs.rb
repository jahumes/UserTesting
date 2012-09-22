class Breadcrumbs < SimpleNavigation::Renderer::Base

  def render(item_container)
    content = a_tags(item_container).join(join_with)
    content_tag(:div,
                prefix_for(content) + content,
                {:id => 'breadcrumbs', :class => item_container.dom_class})
  end

  protected

  def a_tags(item_container)
    item_container.items.inject([]) do |list, item|
      if item.selected?
        list << tag_for(item) if item.selected?
        if include_sub_navigation?(item)
          list.concat a_tags(item.sub_navigation)
        end
      end
      list
    end
  end

  def join_with
    @join_with ||= options[:join_with] || " "
  end

  def suppress_link?(item)
    super || (options[:static_leaf] && item.active_leaf_class)
  end

  def prefix_for(content)
    content.empty? ? '' : options[:prefix] || ''
  end

  # Extracts the options relevant for the generated link
  #
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
