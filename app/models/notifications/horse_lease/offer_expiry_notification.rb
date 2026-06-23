module Notifications::HorseLease
  class OfferExpiryNotification < ::Notification
    def message
      I18n.t("notifications.lease_offer_expiry_notification.message",
        horse: params["horse_name"],
        duration: params["duration"],
        fee: params["fee"])
    end

    def url
      horse_path(params["horse_id"])
    end

    def title
      I18n.t("notifications.lease_offer_expiry_notification.title")
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

