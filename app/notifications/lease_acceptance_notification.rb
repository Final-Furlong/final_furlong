class LeaseAcceptanceNotification < Notification
  def message
    "#{params["stable_name"]} has accepted the lease on #{params["horse_name"]} for #{params["duration"]} for #{params["fee"]}"
  end

  def title
    I18n.t("notifications.lease_acceptance_notification.title")
  end

  def actions
    %w[view_horse]
  end
end

