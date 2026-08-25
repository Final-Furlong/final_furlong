module Notifications::Breeding::Stud
  class AutoBredMaresNotification < ::Notification
    include ActionView::Helpers::UrlHelper
    include Rails.application.routes.url_helpers

    def message
      links = []
      params["mare_ids"].each do |id|
        mare = Horses::Horse.find(id)
        links << I18n.t("notifications.stud_auto_bred_mares.message_html", mare: link_to(mare.name_with_title, horse_path(mare), class: "link"))
      end
      links.join("<br>\n").html_safe # rubocop:disable Rails/OutputSafety
    end

    def title
      I18n.t("notifications.stud_auto_bred_mares.title_count", count: params["mare_ids"].count, stud: params["horse_name"], slot: params["slot"])
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

