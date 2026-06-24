module Users
  module OnlineBadge
    class Component < ApplicationComponent
      attr_reader :online, :status

      def initialize(online:)
        @online = online
        @status = online ? :online : :offline
        super()
      end

      private

      def status_i18n_key
        online ? ".online" : ".offline"
      end

      def css_classes
        ClassVariants.build(
          base: "badge ml-2",
          variants: {
            status: {
              online: "badge-success",
              offline: "bg-light border border-secondary border-opacity-50 text-dark badge-secondary badge-outline"
            }
          },
          defaults: {
            status: :offline
          }
        ).render(status:)
      end
    end
  end
end

