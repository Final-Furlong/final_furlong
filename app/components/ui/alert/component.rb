module Ui
  module Alert
    class Component < ApplicationComponent
      attr_reader :type, :notification, :style, :title, :body, :icon

      def initialize(notification: nil, type: :info, title: "", body: "", style: :normal, icon: false)
        @notification = notification
        @type = notification&.type || type
        @title = notification&.title || title
        @body = notification&.message || body
        @style = style
        @icon = icon
      end

      def icon_description
        I18n.t("icon.#{type.downcase}")
      end

      def mark_as_read_classes
        "btn btn-xs btn-outline btn-primary border-primary/50 text-primary/80 hover:text-primary-content/80"
      end

      def delete_classes
        "btn btn-xs btn-outline btn-error border-error/50 text-error/80 ml-2 hover:text-error-content/80"
      end

      def css_classes
        ClassVariants.build do
          base do
            slot :alert, class: "w-full px-4 py-2 text-sm font-medium border rounded-lg mb-4"
            slot :container, class: "flex flex-row items-center gap-2"
            slot :icon, class: "ph text-2xl sm:text-4xl"
            slot :title, class: "text-lg font-medium"
            slot :body, class: "font-normal"
          end

          variant type: :warning do
            slot :alert, class: "border-warning"
            slot :title, class: "text-warning"
            slot :icon, class: "ph-warning text-warning"
          end

          variant type: :info do
            slot :alert, class: "border-info"
            slot :title, class: "text-info"
            slot :icon, class: "ph-info text-info"
          end

          variant type: :success do
            slot :alert, class: "border-success"
            slot :title, class: "text-success"
            slot :icon, class: "ph-check-circle text-success"
          end

          variant type: :error do
            slot :alert, class: "border-error"
            slot :title, class: "text-error"
            slot :icon, class: "ph-x-circle text-error"
          end

          variant style: :normal do
            slot :container, class: ""
          end

          variant style: :outline do
            slot :container, class: "alert-outline"
          end

          variant style: :soft do
            slot :container, class: "alert-soft"
          end

          variant style: :dash do
            slot :container, class: "alert-dash"
          end
        end
      end
    end
  end
end

