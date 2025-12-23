module Ui
  module Link
    class Component < ApplicationComponent
      attr_reader :color, :style, :url, :http_method, :data, :id, :extra_classes

      def initialize(color: :none, style: :hover, id: nil, url: "#", http_method: :get, data: {}, extra_classes: "")
        @color = color
        @style = style
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
          base: "link inline-flex items-center font-medium transition-colors duration-300",
          variants: {
            color: {
              none: "",
              primary: "link-primary",
              neutral: "link-neutral",
              secondary: "link-secondary",
              accent: "link-accent",
              info: "link-info",
              success: "link-success",
              warning: "link-warning",
              error: "link-error"
            },
            style: {
              none: "",
              hover: "link-hover"
            }
          },
          defaults: {
            color: :primary,
            style: :none
          }
        ).render(color:, style:)
      end
    end
  end
end

