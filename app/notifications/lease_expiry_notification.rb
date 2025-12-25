class LeaseExpiryNotification < Notification
  def message
    "The lease on #{params["horse_name"]} has ended."
  end

  def url
    horse_path(params["horse_id"])
  end

  def title
    I18n.t("notifications.lease_expiry_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse]
  end
end

