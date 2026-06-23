module Notifications::HorseSale
  class OfferNotification < ::Notification
    def message
      I18n.t("notifications.sale_offer_notification.message",
        stable: params["stable_name"],
        horse: params["horse_name"],
        price: params["price"])
    end

    def url
      horse_path(params["horse_id"])
    end

    def title
      I18n.t("notifications.sale_offer_notification.title")
    end

    def actions
      %w[view_horse buy_horse reject_sale]
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

