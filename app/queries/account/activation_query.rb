module Account
  class ActivationQuery
    module Scopes
      def activated
        where.not(activated_at: nil)
      end

      def unactivated
        where(activated_at: nil)
      end
    end

    def query
      @query ||= Activation.extending(Scopes)
    end

    delegate :activated, to: :query

    delegate :unactivated, to: :query
  end
end

