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
          params[:q] ||= {}
          if status == :retired
            set_retired_status
          else
            set_unretired_status
          end

          send(path_name.to_sym, q: params[:q])
        end

        def set_unretired_status
          params[:q].delete(:status_in)
          params[:q][:status_eq] = status
        end

        def set_retired_status
          params[:q].delete(:status_eq)
          params[:q][:status_in] = %i[retired retired_broodmare retired_stud]
        end

        def localised_status(status, count)
          I18n.t("horses.statuses.#{status}").pluralize(count)
        end
    end
  end
end

