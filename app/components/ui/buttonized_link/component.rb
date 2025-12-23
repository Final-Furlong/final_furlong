module Ui
  module ButtonizedLink
    class Component < ApplicationComponent
      attr_reader :color, :size, :rounded, :style, :width, :disabled, :url,
        :http_method, :data, :id, :extra_classes

      def initialize(color: :primary, size: :medium, rounded: :medium, style:
            :normal, width: :normal, disabled: false, id: nil, url: "#",
        http_method: :get, data: {}, extra_classes: "")
        @color = color
        @size = size
        @rounded = rounded
        @style = style
        @width = width
        @disabled = disabled
        @id = id
        @url = url
        @http_method = http_method
        @data = data
        @extra_classes = extra_classes
      end

      def classes
        [css_classes, extra_classes].compact.join(" ")
      end

      def css_classes
        ClassVariants.build(
          base: "btn inline-flex items-center font-medium shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors duration-300",
          variants: {
            color: {
              primary: "btn-primary",
              neutral: "btn-neutral",
              secondary: "btn-secondary",
              accent: "btn-accent",
              info: "btn-info",
              success: "btn-success",
              warning: "btn-warning",
              error: "btn-error"
            },
            size: {
              extra_small: "btn-xs",
              small: "btn-sm",
              medium: "btn",
              large: "btn-lg",
              extra_large: "btn-xl"
            },
            rounded: {
              small: "rounded-sm",
              medium: "rounded-md",
              full: "rounded-full"
            },
            style: {
              soft: "btn-soft",
              normal: "",
              outline: "btn-outline",
              dash: "btn-dash",
              active: "btn-active",
              ghost: "btn-ghost",
              link: "btn-link"
            },
            width: {
              wide: "btn-wide",
              normal: ""
            },
            disabled: "btn-disabled"
          },
          defaults: {
            color: :primary,
            size: :medium,
            rounded: :medium,
            style: :normal,
            width: :normal,
            disabled: false
          }
        ).render(color:, size:, rounded:, style:, width:, disabled:)
      end
    end
  end
end

