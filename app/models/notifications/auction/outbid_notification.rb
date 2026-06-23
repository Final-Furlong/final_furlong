module Notifications::Auction
  class OutbidNotification < ::Notification
    def message
      I18n.t("notifications.auction_outbid_notification.message", name: params["horse_name"], auction: params["auction"])
    end

    def title
      I18n.t("notifications.auction_outbid_notification.title")
    end

    def notification_type
      :error
    end

    def actions
      %w[view_horse view_bidding]
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

