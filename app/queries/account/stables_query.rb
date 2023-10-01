module Account
  class StablesQuery
    module Scopes
      def active
        joins(:user).includes(:user).merge(UsersQuery.new.active)
      end

      def ordered_by_name
        order(name: :asc)
      end

      def name_includes(string)
        where("name ILIKE ?", "%#{string}%")
      end
    end

    def query
      @query ||= Stable.extending(Scopes)
    end

    delegate :active, to: :query

    delegate :ordered_by_name, to: :query

    delegate :name_includes, to: :query
  end
end

