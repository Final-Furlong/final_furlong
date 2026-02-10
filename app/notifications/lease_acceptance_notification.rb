class LeaseAcceptanceNotification < Notification
  def message
    I18n.t("notifications.lease_acceptance_notification.message",
      stable: params["stable_name"],
      horse: params["horse_name"],
      duration: params["duration"],
      fee: params["fee"])
  end

  def title
    I18n.t("notifications.lease_acceptance_notification.title")
  end

  def type
    :success
  end

  def icon
    :success
  end

  def actions
    %w[view_horse]
  end
end

