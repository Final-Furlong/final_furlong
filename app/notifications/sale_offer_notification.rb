class SaleOfferNotification < Notification
  def message
    "#{params["stable_name"]} has offered to sell #{params["horse_name"]} to you for #{params["price"]}"
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

