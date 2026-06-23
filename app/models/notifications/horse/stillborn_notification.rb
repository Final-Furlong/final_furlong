module Notifications::Horse
  class StillbornNotification < ::Notification
    def message
      I18n.t("notifications.horse_stillborn_notification.message", sire:
        params["sire_name"], dam: params["dam_name"])
    end

    def title
      I18n.t("notifications.horse_stillborn_notification.title", mare: params["dam_name"])
    end

    def notification_type
      :error
    end

    def icon
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

