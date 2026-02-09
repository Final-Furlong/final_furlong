class LeaseOfferNotification < Notification
  def message
    I18n.t("notifications.lease_offer_notification.message",
      stable: params["stable_name"],
      horse: params["horse_name"],
      duration: params["duration"],
      fee: params["fee"])
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

