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

  def capture_for_dynamic_fields(model, &block)
    response = nil

    form_with(model:) do |form|
      response = capture(form, &block)
    end

    response
  end

  def old_app_horse_url(id)
    [Rails.application.credentials.dig(:old_app, :horse_url), id].join
  end

  def stakes_string(basic, stakes)
    value = number_to_delimited(basic)
    value += "(#{number_to_delimited(stakes)})" if stakes.positive?
    value
  end
end

