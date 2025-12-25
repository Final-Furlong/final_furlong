class SaleRejectionNotification < Notification
  def message
    "#{params["stable_name"]} has rejected the sale offer on #{params["horse_name"]} for #{params["price"]}"
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

