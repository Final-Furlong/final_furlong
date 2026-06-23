module Notifications::HorseSale
  class RejectionNotification < ::Notification
    def message
      I18n.t("notifications.sale_rejection_notification.message",
        stable: params["stable_name"],
        horse: params["horse_name"],
        price: params["price"])
    end

    def title
      I18n.t("notifications.sale_rejection_notification.title")
    end

    def notification_type
      :error
    end

    def actions
      %w[view_horse]
    end
  end
end

# == Schema Information
#
# Table name: notifications
# Database name: primary
#
#  id         :bigint           not null, primary key
#  params     :jsonb
#  read_at    :datetime
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

