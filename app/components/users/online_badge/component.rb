module Users
  module OnlineBadge
    class Component < ApplicationViewComponent
      def initialize(online:)
        @online = online
        super()
      end

      private

      attr_reader :online

      def status_i18n_key
        online ? ".online" : ".offline"
      end

      def status_classes
        online ? online_classes : offline_classes
      end

      def online_classes
        "badge bg-success badge-online"
      end

      def offline_classes
        "badge bg-light border border-secondary border-opacity-50 text-dark badge-offline"
      end
    end
  end
end

