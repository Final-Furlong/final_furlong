module ApplicationHelper
  include Pagy::Frontend

  def render_turbo_stream_flash_messages
    turbo_stream.replace "flash", partial: "layouts/flash"
  end

  def nav_link_class(args)
    return "active" if current_page?(args)
  end

  def nav_link_active?(args)
    current_page?(args)
  end

  def nav_link_generator(path, &block)
    link_to path, data: { turbo: false }, class: ["list-group-item list-group-item-action py-2 ripple",
                                                  nav_link_class(path)], aria: { current: nav_link_active?(path) } do
      yield block
    end
  end

  def flash_message_type_to_html_class(type)
    case type
    when "alert"
      "danger"
    when "notice"
      "success"
    else
      type
    end
  end
end
