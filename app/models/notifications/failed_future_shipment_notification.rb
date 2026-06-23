module Notifications
  class FailedFutureShipmentNotification < Notification
    def message
      I18n.t("notifications.failed_future_shipment.message", name: params["horse_name"], location: params["location"])
    end

    def title
      I18n.t("notifications.failed_future_shipment.title")
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

