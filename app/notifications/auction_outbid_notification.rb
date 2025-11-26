class AuctionOutbidNotification < Notification
  def message
    "You no longer have the high bid on #{params["horse_name"]} in the #{params["auction"]}"
  end

  def title
    I18n.t("notifications.auction_outbid_notification.title")
  end

  def actions
    %w[view_horse view_bidding]
  end
end

