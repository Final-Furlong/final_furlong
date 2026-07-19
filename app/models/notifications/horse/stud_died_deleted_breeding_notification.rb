module Notifications::Horse
  class StudDiedDeletedBreedingNotification < ::Notification
    def message
      event = I18n.t("#{base_i18n_key}.died")
      I18n.t("#{base_i18n_key}.message", event:, sire:
        params["stud_name"], mare: params["mare_name"], year: Date.current.year)
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
      "notifications.stud_breeding_auto_deleted"
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

