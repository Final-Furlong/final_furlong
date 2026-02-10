class SaleRejectionNotification < Notification
  def message
    I18n.t("notifications.sale_rejection_notification.message",
      stable: params["stable_name"],
      horse: params["horse_name"],
      price: params["price"])
  end

  def title
    I18n.t("notifications.sale_rejection_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_horse]
  end
end

