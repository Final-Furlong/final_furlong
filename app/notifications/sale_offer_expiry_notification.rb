class SaleOfferExpiryNotification < Notification
  def message
    "The sale offer on #{params["horse_name"]} (Price: #{params["price"]}) has
expired."
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

