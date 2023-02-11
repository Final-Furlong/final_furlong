module Account
  class StablesList < BaseOperation
    def call
      authorize_action
      stable_scope = fetch_stables

      Success(stable_scope)
    end

    private

      def authorize_action
        authorize Account::Stable, :index?
      end

      def fetch_stables
        Account::StablesRepository.new.ordered_by_name
      end
  end
end

