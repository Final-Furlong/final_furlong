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

    delegate :ordered, :active, to: :query
  end
end

