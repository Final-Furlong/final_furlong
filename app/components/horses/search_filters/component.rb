require "ransack/helpers/form_helper"

module Horses
  module SearchFilters
    class Component < VariantComponent
      include Ransack::Helpers::FormHelper

      attr_reader :query, :params, :path_name, :statuses, :active_status

      def initialize(version:, query: nil, params: {}, path_name: nil, active_status: nil)
        @path_name = path_name
        @query = query
        @params = params
        if version != :desktop
          localise_statuses
          @active_status = active_status
        end
        super(version:)
      end

      private

      def localise_statuses
        @statuses = []
        HorseStatus::SEARCH_STATUSES.each do |status|
          @statuses << [I18n.t("horses.statuses.#{status}"), status.to_s]
        end
      end
    end
  end
end

