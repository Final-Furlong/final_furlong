class StyledFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    styled_field(method, options,
      input_class: "input input--text") { super(method, options) }
  end

  def email_field(method, options = {})
    styled_field(method, options,
      input_class: "input input--email") { super(method, options) }
  end

  def submit(value = nil, options = {})
    super
  end

  private

  def styled_field(method, options, input_class:)
    hint = options.delete(:hint)
    options[:class] = [input_class, options[:class]].compact.join(" ")

    @template.content_tag(:fieldset, class: "fieldset") do
      label(method) +
        yield +
        hint_tag(hint) +
        error_tag(method)
    end
  end

  def hint_tag(hint)
    return "".html_safe if hint.blank?

    @template.content_tag(:small, hint, class: "hint")
  end

  def error_tag(method)
    message = object&.errors&.[](method)&.first
    return "".html_safe if message.blank?

    @template.content_tag(:span, message, class: "error")
  end
end

