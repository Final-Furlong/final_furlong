class AuctionOutbidNotification < Notification
  def message
    I18n.t("notifications.auction_outbid_notification.message", name: params["horse_name"], auction: params["auction"])
  end

  def title
    I18n.t("notifications.auction_outbid_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse view_bidding]
  end
end

