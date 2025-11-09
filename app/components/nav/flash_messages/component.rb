module Nav
  module FlashMessages
    class Component < ViewComponent::Base
      DEFAULT_TIMEOUT = 3
      NO_DISMISS = -1
      ERROR_TYPES = %w[alert error]

      attr_reader :type, :message, :index, :dismiss_flash_timeout

      def initialize(type:, message:, delay: DEFAULT_TIMEOUT)
        super()
        @type = type.to_s
        @message = message
        @dismiss_flash_timeout = ERROR_TYPES.exclude?(@type) ? delay : NO_DISMISS
      end

      def alert_classes
        case type
        when "alert", "error"
          "alert alert-error"
        when "info"
          "alert alert-info"
        when "success"
          "alert alert-success"
        when "notice"
          "alert alert-warning"
        else
          "alert"
        end
      end

      def icon_class
        case type
        when "alert"
          "fa-circle-exclamation"
        when "info"
          "fa-circle-info"
        when "success"
          "fa-circle-check"
        when "notice"
          "fa-circle-info"
        else
          "fa-circle-info"
        end
      end

      def controller_data
        attrs = { controller: "notification" }
        if dismiss_flash_timeout.positive?
          attrs.merge!(
            "notification-delay-value": DEFAULT_TIMEOUT * 1000,
            "transition-enter-from": "opacity-0 translate-x-6",
            "transition-enter-to": "opacity-100 translate-x-0",
            "transition-leave-from": "opacity-100 translate-x-0",
            "transition-leave-to": "opacity-0 translate-x-6"
          )
        else
          attrs[:"notification-dismiss-value"] = false
        end
        attrs
      end
    end
  end
end

