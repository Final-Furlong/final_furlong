module ApplicationHelper
  def render_load_more(pagy)
    render "shared/load_more", pagy:
  end

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

  def stakes_string(basic, stakes)
    value = number_to_delimited(basic)
    value += "(#{number_to_delimited(stakes)})" if stakes.positive?
    value
  end

  def forum_gender_color_hex(gender)
    case gender.to_s.downcase
    when "colt", "stallion"
      "#0892d0"
    when "filly", "mare"
      "#a40000"
    else
      "#138808"
    end
  end
end

