module Api
  module V1
    class Activity < Grape::API
      include Api::V1::Defaults

      resource :activity do
        desc "Create an activity point entry for a stable"
        params do
          requires :activity_type, type: String, desc: "Type of activity points associated with the transaction"
          requires :legacy_stable_id, type: Integer, desc: "Legacy ID for the stable"
          optional :amount, type: Integer, desc: "Number of activity points to redeem"
        end
        post "/" do
          stable = Account::Stable.find_by!(legacy_id: params[:legacy_stable_id])
          attrs = { stable:, activity_type: params[:activity_type] }
          attrs[:amount] = params[:amount] if params[:amount]
          activity = Accounts::ActivityTransactionCreator.new.create_transaction(**attrs)
          error!({ error: "invalid", detail: activity.errors.full_messages.to_sentence }, 500) unless activity

          { activity_id: activity.id }
        end
      end
    end
  end
end

