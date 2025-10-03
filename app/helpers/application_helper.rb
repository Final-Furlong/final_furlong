module ApplicationHelper
  include Pagy::Frontend

  def render_turbo_stream_flash_messages
    turbo_stream.replace "messages", partial: "layouts/flash"
  end

  def request_variant
    request.variant.first
  end
end

