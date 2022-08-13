module Horses
  class StatusListComponent < ApplicationComponent
    attr_reader :statuses, :active_status, :params, :path_name, :query

    def initialize(statuses:, active_status: nil, params: {}, path_name: nil, query: nil)
      @statuses = statuses
      @active_status = active_status
      @params = params
      @path_name = path_name
      @query = query
      combine_statuses
      super
    end

    private

      def non_empty_status?(status)
        statuses.key?(status)
      end

      def combine_statuses
        statuses.symbolize_keys!
        return statuses unless retired_statuses?

        statuses[:retired] = statuses[:retired] + statuses.delete(:retired_broodmare) + statuses.delete(:retired_stud)
      end

      def retired_statuses?
        statuses.any? { |status| status.first.to_s.start_with?("retired") }
      end

      def status_order
        %i[racehorse broodmare stud weanling yearling retired deceased]
      end
  end
end

