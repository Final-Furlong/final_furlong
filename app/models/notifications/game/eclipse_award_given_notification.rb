module Notifications::Game
  class EclipseAwardGivenNotification < ::Notification
    def message
      winner = %w[stable breeder].include?(params["category"]) ? params["stable_name"] : params["horse_name"]
      I18n.t("notifications.eclipse_award_given_notification.message", winner:)
    end

    def title
      I18n.t("notifications.eclipse_award_given_notification.title", year: params["year"], category: params["category_name"])
    end

    def notification_type
      :info
    end

    def icon
      :info
    end

    def actions
      %w[view_winner]
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

