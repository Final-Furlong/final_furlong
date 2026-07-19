module Notifications::Horse
  class StudDiedDeletedBookingNotification < ::Notification
    def message
      event = I18n.t("#{base_i18n_key}.died")
      mare = params["mare_id"].present? ? params["mare_name"] : I18n.t("#{base_i18n_key}.open")
      I18n.t("#{base_i18n_key}.message", event:, sire:
        params["stud_name"], mare:)
    end

    def title
      event = I18n.t("#{base_i18n_key}.title.died")
      I18n.t("#{base_i18n_key}.title.text", event:, name: params["stud_name"])
    end

    def notification_type
      :error
    end

    def icon
      :error
    end

    def actions
      %w[view_stud view_mare]
    end

    private

    def base_i18n_key
      "notifications.stud_booking_auto_deleted"
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

