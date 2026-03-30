class FailedFutureShipmentNotification < Notification
  def message
    I18n.t("notifications.failed_future_shipment.message", name: params["horse_name"], location: params["location"])
  end

  def title
    I18n.t("notifications.failed_future_shipment.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse]
  end
end

