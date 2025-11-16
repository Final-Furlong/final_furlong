class LeaseOfferExpiryNotification < Notification
  def message
    "The lease offer on #{params["horse_name"]} for #{params["duration"]} (Fee: #{params["fee"]}) has expired."
  end

  def url
    horse_path(params["horse_id"])
  end

  def title
    I18n.t("notifications.lease_offer_expiry_notification.title")
  end

  def actions
    %w[view_horse]
  end
end

