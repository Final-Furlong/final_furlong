class LeaseRejectionNotification < Notification
  def message
    "#{params["stable_name"]} has rejected the lease offer on #{params["horse_name"]} for #{params["fee"]}"
  end

  def title
    I18n.t("notifications.lease_rejection_notification.title")
  end

  def actions
    %w[view_horse]
  end
end

