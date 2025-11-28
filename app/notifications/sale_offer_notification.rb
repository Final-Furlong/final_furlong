class SaleOfferNotification < Notification
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

