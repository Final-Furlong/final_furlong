class LeaseRejectionNotification < Notification
  def message
    I18n.t("notifications.lease_rejection_notification.message",
      stable: params["stable_name"],
      horse: params["horse_name"],
      fee: params["fee"])
  end

  def title
    I18n.t("notifications.lease_rejection_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse]
  end
end

