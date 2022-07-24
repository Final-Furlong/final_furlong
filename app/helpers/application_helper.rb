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
end
