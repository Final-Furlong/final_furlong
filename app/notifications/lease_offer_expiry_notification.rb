class LeaseOfferExpiryNotification < Notification
  def message
    I18n.t("notifications.lease_offer_expiry_notification.message",
      horse: params["horse_name"],
      duration: params["duration"],
      fee: params["fee"])
  end

  def url
    horse_path(params["horse_id"])
  end

  def title
    I18n.t("notifications.lease_offer_expiry_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse]
  end
end

