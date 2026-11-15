require "ransack/helpers/form_helper"

module Horses
  module StatusSearch
    class Component < VariantComponent
      include Ransack::Helpers::FormHelper

      attr_reader :statuses, :status, :active_status, :params, :path_name

      # rubocop:disable Metrics/ParameterLists
      def initialize(version:, statuses:, status: nil, active_status: nil, params: {}, path_name: nil)
        @statuses = statuses
        @status = status
        @active_status = active_status
        @params = params.presence || { "q" => {} }
        @path_name = path_name
        super(version:)
      end

      # rubocop:enable Metrics/ParameterLists

      private

      def render?
        statuses.key?(status)
      end

      def url_with_params(status)
        @params = set_state_value(status)
        @params = set_status_value(status)
        @params = update_genders_list

        send(path_name.to_sym, q: params["q"])
      end

      def set_state_value(status)
        state = %i[retired deceased].include?(status.to_sym) ? status.to_s.downcase : "active"

        params["q"]["state_eq"] = state
        params
      end

      def set_status_value(status)
        if %i[retired deceased].include?(status.to_sym)
          params["q"]["age_eq"] = nil
          params["q"]["type_eq"] = nil
        elsif %i[weanling yearling].include?(status)
          params["q"]["type_eq"] = "Horses::Horse::Foal"
          params["q"]["age_eq"] = (status == :yearling) ? 1 : 0
        else
          params["q"]["type_eq"] = "Horses::Horse::#{status.to_s.capitalize}"
          params["q"]["state_eq"] = "active"
          params["q"]["age_eq"] = nil
        end
        params
      end

      def update_genders_list
        return params unless params&.dig("q", "gender_in")

        params["q"]["gender_in"] = params["q"]["gender_in"].join(",")
        params
      end

      def localised_status(status, count)
        I18n.t("horses.statuses.#{status}").pluralize(count)
      end
    end
  end
end

