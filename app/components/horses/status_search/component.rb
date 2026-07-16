require "ransack/helpers/form_helper"

module Horses
  module StatusSearch
    class Component < VariantComponent
      include Ransack::Helpers::FormHelper

      attr_reader :statuses, :status, :active_status, :params, :path_name

      # rubocop:disable Metrics/ParameterLists
      def initialize(version:, statuses:, status: nil, active_status: nil, params: {}, path_name: nil)
        pd statuses
        @statuses = statuses
        @status = status
        @active_status = active_status
        @params = params
        @path_name = path_name
        super(version:)
      end

      # rubocop:enable Metrics/ParameterLists

      private

      def render?
        statuses.key?(status)
      end

      def url_with_params(status)
        params ||= {}
        params[:q] ||= {}
        params = set_state_value(params, status)
        params = set_status_value(params, status)
        params = update_genders_list(params)

        send(path_name.to_sym, q: params[:q])
      end

      def set_state_value(params, status)
        state = %i[retired deceased].include?(status) ? status : "active"

        params[:q][:state_eq] = state
        params
      end

      def set_status_value(params, status)
        return params if %i[retired deceased].include?(status)

        if %i[weanling yearling].include?(status)
          params[:q][:type_eq] = "Horses::Horse::Foal"
          params[:q][:age_eq] = (status == :yearling) ? 1 : 0
        else
          params[:q][:type_eq] = "Horses::Horse::#{status.to_s.capitalize}"
          params[:q][:state_eq] = "active"
        end
        params
      end

      def update_genders_list(params)
        return params unless params&.dig(:q, :gender_in)

        params[:q][:gender_in] = params[:q][:gender_in].join(",")
      end

      def localised_status(status, count)
        I18n.t("horses.statuses.#{status}").pluralize(count)
      end
    end
  end
end

