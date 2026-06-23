module Notifications::Horse
  class BornNotification < ::Notification
    def message
      if params["created"]
        I18n.t("notifications.horse_born_notification.message_created")
      else
        I18n.t("notifications.horse_born_notification.message", sire:
          params["sire_name"], dam: params["dam_name"])
      end
    end

    def title
      name = params["created"] ? I18n.t("horse.created") : params["dam_name"]
      I18n.t("notifications.horse_born_notification.title", mare: name)
    end

    def notification_type
      :success
    end

    def icon
      :success
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

