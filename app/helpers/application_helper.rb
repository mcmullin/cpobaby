module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "CPObaby"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns the flash class
  def flash_class(type)
    case type
    when :success
      'alert-success'
    when :notice
      'alert-success'
    when :info
      'alert-info'
    when :warning
      'alert-warning'
    when :error
      'alert-danger'
    when :alert
      'alert-danger'
    else
      ''
    end
  end
end
