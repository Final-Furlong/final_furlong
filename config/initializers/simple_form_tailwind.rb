# # Use this setup block to configure all options available in SimpleForm.
# require_relative '../../app/helpers/tailwind_helper'
#
# SimpleForm.setup do |config|
#   config.button_class = "my-2 bg-blue-500 hover:bg-blue-700 text-white font-bold text-sm py-2 px-4 rounded"
#   config.boolean_label_class = nil
#   include TailwindHelper
#
#   config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }
#
#   config.boolean_style = :inline
#
#   config.item_wrapper_tag = :div
#
#   config.include_default_input_wrapper_class = false
#
#   config.error_notification_class = "float-none text-white px-6 py-4 border-0 rounded relative mb-4 bg-red-400"
#
#   # Method used to tidy up errors. Specify any Rails Array method.
#   # :first lists the first message for each field.
#   # :to_sentence to list all errors for each field.
#   config.error_method = :to_sentence
#
#   # add validation classes to `input_field`
#   config.input_field_error_class = tw_error_field
#   config.input_field_valid_class = tw_valid_field
#   config.label_class = "text-sm font-medium text-gray-600 dark:text-gray-100"
#
#   # vertical forms
#   #
#   # vertical default_wrapper
#   config.wrappers :vertical_form, tag: "div", class: "my-4", error_class: 'has-error' do |b|
#     b.use :html5
#     b.use :placeholder
#     b.optional :maxlength
#     b.optional :minlength
#     b.optional :pattern
#     b.optional :min_max
#     b.optional :readonly
#     b.use :label, class: tw_label
#     b.wrapper tag: 'div', class: 'mt-1 rounded-md shadow-sm' do |ba|
#       ba.use :input, class: tw_field
#       ba.use :full_error, wrap_with: { tag: "span", class: "mt-2 text-sm text-red-600 dark:text-red-500" }
#       ba.use :hint, wrap_with: { tag: "p", class: "mt-2 text-sm text-gray-500 dark:text-gray-400" }
#     end
#   end
#
#   # vertical input for boolean
#   config.wrappers :vertical_boolean, tag: "div", class: "flex items-start mb-5" do |b|
#     b.use :html5
#     b.optional :readonly
#     b.wrapper :form_check_wrapper, class: "flex items-center h-5" do |bb|
#       bb.use :input, class: tw_boolean_field
#     end
#     b.use :label, class: tw_boolean_label
#     b.use :full_error, wrap_with: { class: "invalid-feedback" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # vertical input for radio buttons and check boxes
#   config.wrappers :vertical_collection, item_wrapper_class: "form-check", item_label_class: "form-check-label", tag: "fieldset", class: "mb-3" do |b|
#     b.use :html5
#     b.optional :readonly
#     b.wrapper :legend_tag, tag: "legend", class: "col-form-label pt-0" do |ba|
#       ba.use :label_text
#     end
#     b.use :input, class: "form-check-input", error_class: "is-invalid", valid_class: "is-valid"
#     b.use :full_error, wrap_with: { class: "invalid-feedback d-block" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # vertical input for inline radio buttons and check boxes
#   config.wrappers :vertical_collection_inline, item_wrapper_class: "form-check form-check-inline", item_label_class: "form-check-label", tag: "fieldset", class: "mb-3" do |b|
#     b.use :html5
#     b.optional :readonly
#     b.wrapper :legend_tag, tag: "legend", class: "col-form-label pt-0" do |ba|
#       ba.use :label_text
#     end
#     b.use :input, class: "form-check-input", error_class: "is-invalid", valid_class: "is-valid"
#     b.use :full_error, wrap_with: { class: "invalid-feedback d-block" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # vertical file input
#   config.wrappers :vertical_file, class: "mb-3" do |b|
#     b.use :html5
#     b.use :placeholder
#     b.optional :maxlength
#     b.optional :minlength
#     b.optional :readonly
#     b.use :label, class: "form-label"
#     b.use :input, class: "form-control", error_class: "is-invalid", valid_class: "is-valid"
#     b.use :full_error, wrap_with: { class: "invalid-feedback" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # vertical select input
#   config.wrappers :vertical_select, class: "mb-3" do |b|
#     b.use :html5
#     b.optional :readonly
#     b.use :label, class: "form-label"
#     b.use :input, class: "form-select", error_class: "is-invalid", valid_class: "is-valid"
#     b.use :full_error, wrap_with: { class: "invalid-feedback" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # vertical multi select
#   config.wrappers :vertical_multi_select, class: "mb-3" do |b|
#     b.use :html5
#     b.optional :readonly
#     b.use :label, class: "form-label"
#     b.wrapper class: "d-flex flex-row justify-content-between align-items-center" do |ba|
#       ba.use :input, class: "form-select mx-1", error_class: "is-invalid", valid_class: "is-valid"
#     end
#     b.use :full_error, wrap_with: { class: "invalid-feedback d-block" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # vertical range input
#   config.wrappers :vertical_range, class: "mb-3" do |b|
#     b.use :html5
#     b.use :placeholder
#     b.optional :readonly
#     b.optional :step
#     b.use :label, class: "form-label"
#     b.use :input, class: "form-range", error_class: "is-invalid", valid_class: "is-valid"
#     b.use :full_error, wrap_with: { class: "invalid-feedback" }
#     b.use :hint, wrap_with: { class: "form-text" }
#   end
#
#   # The default wrapper to be used by the FormBuilder.
#   config.default_wrapper = :vertical_form
#
#   # Custom wrappers for input types. This should be a hash containing an input
#   # type as key and the wrapper that will be used for all inputs with specified type.
#   config.wrapper_mappings = {
#     boolean: :vertical_boolean,
#     check_boxes: :vertical_collection,
#     date: :vertical_multi_select,
#     datetime: :vertical_multi_select,
#     file: :vertical_file,
#     radio_buttons: :vertical_collection,
#     range: :vertical_range,
#     time: :vertical_multi_select,
#     select: :vertical_select
#   }
# end

