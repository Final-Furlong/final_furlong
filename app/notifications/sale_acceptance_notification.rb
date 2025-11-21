class SaleAcceptanceNotification < Notification
  def message
    "#{params["stable_name"]} has purchased #{params["horse_name"]} for #{params["price"]}"
  end

  def title
    I18n.t("notifications.sale_acceptance_notification.title")
  end

  def actions
    %w[view_horse]
  end
end

