module Account
  class ActivationQuery
    module Scopes
      def activated
        where.not(activated_at: nil)
      end

      def unactivated
        where(activated_at: nil)
      end

      def exists_with_token?(stable_name:, token:)
        Account::Stable.joins(user: :activation).exists?(
          name: stable_name,
          user: { activations: { token: } }
        )
      end
    end

    def query
      @query ||= Activation.extending(Scopes)
    end

    delegate :activated, :unactivated, :exists_with_token?, to: :query
  end
end

