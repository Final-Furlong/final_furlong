module Accounts
  module Stable
    class ActionsListGenerator
      include Rails.application.routes.url_helpers

      attr_reader :stable

      def call(stable:)
        @stable = stable
        actions.select do |action_hash|
          policy_class = action_hash[:policy] || Account::StablePolicy
          if action_hash[:object]
            begin
              subject = stable.send(action_hash[:object])
              policy_class.new(Current.user, subject).send("#{action_hash[:key]}?")
            rescue
              false
            end
          else
            policy_class.new(Current.user, stable).send("#{action_hash[:key]}?")
          end
        end.map do |action|
          action[:object] ? [action[:key], action[:object]].join("_") : action[:key]
        end
      end

      private

      def actions
        [
          { key: :impersonate },
          { key: :edit }
        ]
      end
    end
  end
end

