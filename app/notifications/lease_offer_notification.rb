class LeaseOfferNotification < Notification
  def message
    "#{params["stable_name"]} has offered to lease #{params["horse_name"]} to you for #{params["duration"]} for #{params["fee"]}"
  end

  def url
    horse_path(params["horse_id"])
  end

  def title
    I18n.t("notifications.lease_offer_notification.title")
  end

  def actions
    %w[view_horse accept_lease reject_lease]
  end
end

