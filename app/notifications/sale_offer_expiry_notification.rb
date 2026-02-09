class SaleOfferExpiryNotification < Notification
  def message
    I18n.t("notifications.sale_offer_expiry_notification.message",
      horse: params["horse_name"],
      price: params["price"])
  end

  def url
    horse_path(params["horse_id"])
  end

  def title
    I18n.t("notifications.sale_offer_expiry_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse]
  end
end

