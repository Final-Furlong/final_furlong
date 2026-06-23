module Notifications::Breeding::Stud
  class BookingRequestNotification < ::Notification
    def message
      key = "notifications.stud_booking_request_notification.message"
      i18n_params = { stable: params["stable_name"], stud: params["stud_name"], mare: params["mare_name"], start: params["slot_start_date"], end: params["slot_end_date"] }
      if params["message"]
        key += "_with_comment"
        i18n_params[:comment] = params["message"]
      end
      I18n.t(key, **i18n_params)
    end

    def title
      I18n.t("notifications.stud_booking_request_notification.title")
    end

    def notification_type
      :info
    end

    def actions
      %w[view_stud view_mare]
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

