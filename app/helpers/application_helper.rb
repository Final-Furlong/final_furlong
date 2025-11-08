module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.replace("messages", partial: "layouts/flash")
  end

  def request_variant
    request.variant.first
  end

  def mobile_variant?
    request.variant.include?(:phone)
  end
end

