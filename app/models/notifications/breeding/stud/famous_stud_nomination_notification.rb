module Notifications::Breeding::Stud
  class FamousStudNominationNotification < ::Notification
    include ActionView::Helpers::UrlHelper
    include Rails.application.routes.url_helpers

    def message
      I18n.t("notifications.famous_stud_nominations_notification.message", date: I18n.l(date))
    end

    def title
      I18n.t("notifications.famous_stud_nominations_notification.title")
    end

    def notification_type
      :info
    end

    def actions
      %w[view_nominations]
    end

    def date
      params["date"].is_a?(Date) ? params["date"] : Date.parse(params["date"])
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

