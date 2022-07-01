# typed: false

module ApplicationHelper
  include Pagy::Frontend

  def render_turbo_stream_flash_messages
    turbo_stream.replace "flash", partial: "layouts/flash"
  end
end
