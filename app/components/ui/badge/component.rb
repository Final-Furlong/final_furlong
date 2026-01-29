module Ui
  module Badge
    class Component < ApplicationComponent
      attr_reader :color, :size, :style, :extra_classes

      def initialize(color: :primary, size: :medium, style: :normal, extra_classes: "")
        @color = color
        @size = size
        @style = style
        @extra_classes = extra_classes
      end

      private

      def classes
        [css_classes, extra_classes].compact.join(" ")
      end

      def css_classes
        ClassVariants.build(
          base: "badge font-medium shadow-sm",
          variants: {
            color: {
              primary: "badge-primary",
              neutral: "badge-neutral",
              secondary: "btn-secondary",
              accent: "badge-accent",
              info: "badge-info",
              success: "badge-success",
              warning: "badge-warning",
              error: "badge-error"
            },
            size: {
              extra_small: "badge-xs",
              small: "badge-sm",
              medium: "badge-md",
              large: "badge-lg",
              extra_large: "badge-xl"
            },
            style: {
              soft: "badge-soft",
              normal: "",
              outline: "badge-outline",
              dash: "badge-dash",
              ghost: "badge-ghost"
            }
          },
          defaults: {
            color: :primary,
            size: :medium,
            style: :normal,
            disabled: false
          }
        ).render(color:, size:, style:)
      end
    end
  end
end

