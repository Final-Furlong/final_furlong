module Horses
  module StatusList
    class Component < VariantComponent
      attr_reader :statuses, :active_status, :params, :path_name

      # rubocop:disable Metrics/ParameterLists
      def initialize(version:, variants:, statuses:, active_status: nil, params: {}, path_name: nil)
        @statuses = statuses.symbolize_keys
        @active_status = active_status
        @params = params
        @path_name = path_name
        super(version:, variants:)
      end
      # rubocop:enable Metrics/ParameterLists

      private

      def render?
        version == :desktop
      end

      def non_empty_status?(status)
        statuses.key?(status)
      end

      def status_order
        %i[racehorse broodmare stud yearling weanling retired deceased]
      end
    end
  end
end

