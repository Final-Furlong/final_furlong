module Horses
  class StatusListComponent < VariantComponent
    attr_reader :statuses, :active_status, :params, :path_name

    # rubocop:disable Metrics/ParameterLists
    def initialize(version:, variants:, statuses:, active_status: nil, params: {}, path_name: nil)
      @statuses = statuses.symbolize_keys
      @active_status = active_status
      @params = params
      @path_name = path_name
      combine_statuses
      super(version:, variants:)
    end
    # rubocop:enable Metrics/ParameterLists

    private

      def non_empty_status?(status)
        statuses.key?(status)
      end

      def combine_statuses
        return statuses unless retired_statuses?

        statuses[:retired] = retired_status + retired_broodmare_status + retired_stud_status
      end

      def retired_status
        statuses[:retired].to_i
      end

      def retired_broodmare_status
        statuses.delete(:retired_broodmare).to_i
      end

      def retired_stud_status
        statuses.delete(:retired_stud).to_i
      end

      def retired_statuses?
        statuses.any? { |status| status.first.to_s.start_with?("retired") }
      end

      def status_order
        %i[racehorse broodmare stud weanling yearling retired deceased]
      end
  end
end

