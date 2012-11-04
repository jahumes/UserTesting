module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def sortable(column, args = {})
    args[:title] ||= column.titleize
    css_class = column == sort_column ? "sorting #{sort_direction}" : 'sorting'
    html_options = args[:html_options] ? args[:html_options] : {}
    html_options[:class] = html_options[:class] ? html_options[:class] + ' ' + css_class : css_class
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    content_tag :td, (link_to args[:title], params.merge(:sort => column, :direction => direction, :page => nil)), html_options
  end
end
