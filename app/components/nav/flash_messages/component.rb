module Nav
  module FlashMessages
    class Component < ViewComponent::Base
      DEFAULT_TIMEOUT = 5
      NO_DISMISS = -1

      attr_reader :type, :message, :index, :dismiss_flash_timeout

      def initialize(type:, message:, index: 0)
        super()
        @type = type.to_s
        @message = message
        @index = 0
        @dismiss_flash_timeout = (@type != "alert") ? DEFAULT_TIMEOUT : NO_DISMISS
      end

      def alert_classes
        case type
        when "alert"
          "text-red-800 border-red-300 bg-red-50 dark:text-red-400 dark:bg-gray-800 dark:ring-gray-200 dark:border-gray-900"
        when "info"
          "text-blue-800 border-blue-300 bg-blue-50 dark:text-blue-400 dark:bg-gray-800 dark:ring-gray-200 dark:border-gray-900"
        when "success"
          "text-green-800 border-green-300 bg-green-50 dark:text-green-400 dark:bg-gray-800 dark:ring-gray-200 dark:border-gray-900"
        when "notice"
          "text-yellow-800 border-yellow-300 bg-yellow-50 dark:text-yellow-300 dark:bg-gray-800 dark:ring-gray-200 dark:border-gray-900"
        else
          "text-gray-800 dark:text-gray-300"
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

      def close_button_classes
        case type
        when "alert"
          "bg-red-50 text-red-500 focus:ring-red-400 p-1.5 hover:bg-red-200 dark:bg-gray-800 dark:text-red-400 dark:hover:bg-gray-700"
        when "info"
          "bg-blue-50 text-blue-500 focus:ring-blue-400 hover:bg-blue-200 dark:bg-gray-800 dark:text-blue-400 dark:hover:bg-gray-700"
        when "success"
          "bg-green-50 text-green-500 focus:ring-green-400 hover:bg-green-200 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700"
        when "notice"
          "bg-yellow-50 text-yellow-500 focus:ring-yellow-400 hover:bg-yellow-200 dark:bg-gray-800 dark:text-yellow-300 dark:hover:bg-gray-700"
        else
          "bg-gray-50 text-gray-500 focus:ring-gray-400 hover:bg-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700 dark:hover:text-white"
        end
      end

      def flash_message_controller_data
        {
          controller: "flash-messages",
          "flash-messages-target": "flash",
          "flash-messages-dismiss-flash-timeout-value": dismiss_flash_timeout
        }
      end
    end
  end
end

