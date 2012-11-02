class PaginationListLinkRenderer < WillPaginate::ActionView::LinkRenderer

  def container_attributes
    super.except(:first_label, :last_label)
  end

  def pagination
    items = @options[:page_links] ? windowed_page_numbers : []
    items.unshift :previous_page
    items.unshift :first_page
    items.push :next_page
    items.push :last_page
  end

  protected

  def page_number(page)
    unless page == current_page
      tag(:li, link(page, page, :rel => rel_value(page)))
    else
      tag(:li, link(page, '#', :rel => rel_value(page), :class => 'active'), :class => "current")
    end
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, @options[:previous_label], 'prev')
  end

  def next_page
    num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
    previous_or_next_page(num, @options[:next_label], 'next')
  end

  def previous_or_next_page(page, text, classname)
    if page
      tag(:li, link(text, page), :class => classname)
    else
      tag(:li, link(text, '#'), :class => classname + ' disabled')
    end
  end

  def html_container(html)
    tag(:ul, html, container_attributes)
  end

  def first_page
    previous_or_next_page(current_page == 1 ? nil : 1, @options[:first_label], "first_page")
  end

  def last_page
    previous_or_next_page(current_page == total_pages ? nil : total_pages, @options[:last_label], "last_page")
  end

end