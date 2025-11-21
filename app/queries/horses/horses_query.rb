module Horses
  class HorsesQuery
    module Scopes
      def name_matches(name)
        return none if name.blank?

        formatted_name = name.downcase.tr(" ", "").tr(".", "").tr("-", "").tr("&", "").tr("'", "")
        where("LOWER(REGEXP_REPLACE(name, '[^a-zA-Z0-9]+','', 'g')) = ?", formatted_name)
      end

      def born
        where.not(status: Status::STATUSES[:unborn])
      end

      def living
        where(status: Status::LIVING_STATUSES)
      end

      def retired
        where(status: Status::RETIRED_STATUSES)
      end

      def ordered
        order(name: :asc)
      end

      def owned_by(stable)
        where(owner: stable)
      end

      def sort_by_status_asc
        in_order_of(:status, status_array_order).order(name: :asc)
      end

      private

      def status_array_order
        localized_statuses.sort.map { |_key, value| value }
      end

      def localized_statuses
        Horse.statuses.transform_keys { |key| Horse.human_attribute_name("status.#{key}") }
      end
    end

    def query
      @query ||= Horse.extending(Scopes)
    end

    def name_matches(filters)
      query.name_matches(filters[:name])
    end

    delegate :born, to: :query

    delegate :living, to: :query

    delegate :retired, to: :query

    delegate :ordered, to: :query

    delegate :owned_by, to: :query

    delegate :sort_by_status_asc, to: :query
  end
end

