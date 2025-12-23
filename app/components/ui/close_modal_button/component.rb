module Ui
  module CloseModalButton
    class Component < ApplicationComponent
      attr_reader :text, :color, :size, :rounded, :style, :width, :disabled,
        :id, :extra_classes, :onclick

      def initialize(text: nil, color: :primary, size: :medium, rounded:
            :medium, style: :normal, width: :normal, disabled: false, id: nil,
        extra_classes: "", onclick: nil)
        @text = text || I18n.t("common.actions.cancel")
        @color = color
        @size = size
        @rounded = rounded
        @style = style
        @width = width
        @disabled = disabled
        @id = id
        @extra_classes = extra_classes
        @onclick = onclick
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

