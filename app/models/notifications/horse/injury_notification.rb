module Notifications::Horse
  class InjuryNotification < ::Notification
    def message
      key = "notifications.horse_injury_notification.message"
      injury_text = I18n.t("notifications.horse_injury_notification.injuries.#{params["injury"]}")
      i18n_params = { horse: params["horse_name"], injury: injury_text }
      if params["leg"]
        key += "_with_leg"
        i18n_params[:leg] = params["leg"]
      end

      I18n.t(key, **i18n_params)
    end

    def title
      I18n.t("notifications.horse_injury_notification.title")
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

