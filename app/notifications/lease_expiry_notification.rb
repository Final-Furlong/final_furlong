class LeaseExpiryNotification < Notification
  def message
    I18n.t("notifications.lease_expiry_notification.message", name: params["horse_name"])
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

