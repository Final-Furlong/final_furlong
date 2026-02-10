class SaleAcceptanceNotification < Notification
  def message
    I18n.t("notifications.sale_acceptance_notification.message",
      stable: params["stable_name"],
      horse: params["horse_name"],
      price: params["price"])
  end

  def title
    I18n.t("notifications.sale_acceptance_notification.title")
  end

  def type
    :success
  end

  def actions
    %w[view_horse]
  end
end

