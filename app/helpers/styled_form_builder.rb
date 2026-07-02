require "action_view"

class StyledFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, :safe_join, :capture, to: :@template

  def text_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def email_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def password_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def number_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def telephone_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end
  alias_method :phone_field, :telephone_field

  def url_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def date_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def datetime_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def time_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def color_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input-color")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def search_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "input")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def text_area(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "textarea")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def select(method, choices = nil, options = {}, html_options = {})
    field_wrapper(method, html_options) do
      add_default_class!(html_options, "select")
      add_error_class!(html_options) if has_error?(method)
      super(method, choices, options, html_options)
    end
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    wrapper_options = options.delete(:wrapper)
    label_text = options.delete(:label)
    label_class = options.delete(:label_class)
    is_required = options.delete(:required) || false
    help_text = options.delete(:help) || options.delete(:hint)

    # If wrapper is explicitly false, return just the checkbox without wrapping
    if wrapper_options == false
      add_error_class!(options) if has_error?(method)
      return super
    end

    wrapper_options ||= {}

    # Set default flex layout for the wrapper
    wrapper_class = "fieldset"
    wrapper_options[:class] = [wrapper_class, wrapper_options[:class]].compact.join(" ")

    content_tag(:fieldset, wrapper_options) do
      add_default_class!(options, "checkbox")
      add_error_class!(options) if has_error?(method)

      if label_text
        label_options = { class: label_class }
        label_options[:required] = true if is_required
        elements = []
        elements << label(method, label_text, label_options) do
          safe_join([super(method, options, checked_value, unchecked_value), label_text])
        end
        elements << error_message(method) if has_error?(method)
        elements << form_help(help_text) if has_hint?(help_text)
        safe_join(elements)
      else
        super(method, options, checked_value, unchecked_value)
      end
    end
  end

  def radio_button(method, tag_value, options = {})
    wrapper_options = options.delete(:wrapper)
    label_text = options.delete(:label)

    # If wrapper is explicitly false, return just the radio button without wrapping
    if wrapper_options == false
      add_error_class!(options) if has_error?(method)
      return super
    end

    wrapper_options ||= {}

    # Set default flex layout for the wrapper
    wrapper_class = "flex items-center justify-start gap-2"
    wrapper_options[:class] = [wrapper_class, wrapper_options[:class]].compact.join(" ")

    content_tag(:fieldset, wrapper_options) do
      add_default_class!(options, "radio")
      add_error_class!(options) if has_error?(method)

      if label_text
        radio_html = super(method, tag_value, options)
        label_html = label(method, label_text, value: tag_value, class: "label")
        safe_join([radio_html, label_html])
      else
        super(method, tag_value, options)
      end
    end
  end

  def file_field(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "file")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def rich_text_area(method, options = {})
    field_wrapper(method, options) do
      add_default_class!(options, "trix-content")
      add_error_class!(options) if has_error?(method)
      super(method, options)
    end
  end

  def range_field(method, options = {})
    # Extract wrapper options and add stimulus controller to the form group
    wrapper_options = options.delete(:wrapper) || {}
    wrapper_options["data-controller"] = "railsui-range"

    field_wrapper(method, options.merge(wrapper: wrapper_options)) do
      add_default_class!(options, "form-input-range")
      add_error_class!(options) if has_error?(method)

      # Add stimulus target and action data attributes to the input
      options["data-railsui-range-target"] = "range"
      options["data-action"] = "input->railsui-range#onInput"

      super(method, options)
    end
  end

  def switch_field(method, options = {})
    wrapper_options = options.delete(:wrapper)
    label_text = options.delete(:label) || method.to_s.humanize

    add_default_class!(options, "toggle")
    add_error_class!(options) if has_error?(method)

    # Create switch input without hidden field
    switch_html = @template.check_box(@object_name, method, objectify_options(options.merge(include_hidden: false)), "1", "0")
    label_html = label(method, label_text, class: "")
    switch_content = safe_join([switch_html, label_html])

    # If wrapper is explicitly false, return just the switch without wrapping
    if wrapper_options == false
      return switch_content
    end

    field_wrapper(method, { wrapper: wrapper_options, label: false }) do
      switch_content
    end
  end

  def button_toggle(method, tag_value, options = {})
    label_text = options.delete(:label) || tag_value.to_s.humanize
    variant = options.delete(:variant) # sm, lg, ghost, muted

    field_wrapper(method, options.merge(label: label_text)) do
      base_class = "form-input-button-toggle"
      base_class += "-#{variant}" if variant
      add_default_class!(options, base_class)

      # Call ActionView radio_button helper directly to avoid flex wrapper
      @template.radio_button(@object_name, method, tag_value, objectify_options(options))
    end
  end

  def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    add_error_class!(options) if has_error?(method)

    field_wrapper(method, options.merge(use_legend: true)) do
      super(method, collection, value_method, text_method, options, html_options) do |b|
        b.label(class: "label") { b.radio_button(class: "radio") + b.text }
      end
    end
  end

  def label(method, text = nil, options = {})
    add_default_class!(options, "label")
    add_error_class!(options, "text") if has_error?(method)
    # Check both the required option and model validators
    is_required = options.delete(:required) || required_field?(method)
    options[:class] += " required" if is_required
    super
  end

  def legend(method, text = nil, options = {})
    add_default_class!(options, "fieldset-legend")
    add_error_class!(options, "text") if has_error?(method)
    # Check both the required option and model validators
    is_required = options.delete(:required) || required_field?(method)
    options[:class] += " required" if is_required
    content_tag(:legend, class: options[:class]) do
      text
    end
  end

  def error_message(method)
    return unless has_error?(method)

    errors = @object.errors[method]
    if errors.blank? && method.to_s.ends_with?("_id")
      errors = @object.errors[method.slice(0, method.length - 3)]
    end
    content_tag(:p, class: "mt-1 text-sm text-red-600 dark:text-red-400") do
      errors.join(", ")
    end
  end

  def fieldset(method = nil, options = {}, &block)
    content_tag(:fieldset, class: "fieldset #{options[:class]}", &block)
  end

  def submit(value = nil, options = {})
    add_default_class!(options, "btn btn-primary")
    super
  end

  private

  def field_wrapper(method, options = {}, &block)
    wrapper_options = options.delete(:wrapper)
    label_text = options.delete(:label)
    skip_label = options.delete(:skip_label) || false
    use_legend = options.delete(:use_legend) || false
    help_text = options.delete(:help) || options.delete(:hint)
    is_required = options[:required] || false

    # If wrapper is explicitly false, just return the field without wrapping
    if wrapper_options == false
      return capture(&block)
    end

    wrapper_options ||= {}

    fieldset(method, wrapper_options) do
      elements = []

      # Add label unless skipped
      unless skip_label || use_legend
        label_options = options.delete(:label_options) || {}
        # Pass the required flag to the label
        label_options[:required] = is_required if is_required
        elements << label(method, label_text, label_options) if label_text != false
      end
      if use_legend
        label_options = options.delete(:label_options) || {}
        # Pass the required flag to the label
        label_options[:required] = is_required if is_required
        elements << legend(method, label_text, label_options) if label_text != false
      end

      # Add the field
      elements << capture(&block)
      elements << error_message(method) if has_error?(method)
      elements << form_help(help_text) if has_hint?(help_text)

      safe_join(elements)
    end
  end

  def form_help(text, options = {})
    add_default_class!(options, "label")
    content_tag(:p, text, options)
  end

  def add_default_class!(options, css_class)
    options[:class] = [css_class, options[:class]].compact.join(" ")
  end

  def add_error_class!(options, type = "input")
    options[:class] = [options[:class], "#{type}-error"].compact.join(" ")
  end

  def has_hint?(text)
    text.present?
  end

  def has_error?(method)
    return false unless @object.respond_to?(:errors)
    return true if @object.errors[method].present?

    if method.to_s.ends_with?("_id")
      @object.errors[method.slice(0, method.length - 3)].present?
    else
      false
    end
  end

  def required_field?(method)
    return false unless @object.class.respond_to?(:validators_on)

    @object.class.validators_on(method).any? do |validator|
      validator.is_a?(ActiveModel::Validations::PresenceValidator)
    end
  end
end

