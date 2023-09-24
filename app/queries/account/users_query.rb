module Account
  class UsersQuery
    module Scopes
      def ordered
        order(created_at: :desc)
      end
    end

    def query
      @query ||= User.extending(Scopes)
    end

    def active
      User.active
    end

    delegate :ordered, to: :query
  end
end

