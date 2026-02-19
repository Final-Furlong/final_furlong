class HorsePrematureNotification < Notification
  def message
    I18n.t("notifications.horse_premature_notification.message", sire: params["sire_name"], dam: params["dam_name"])
  end

  def title
    I18n.t("notifications.horse_premature_notification.title", mare: params["dam_name"])
  end

  def type
    :success
  end

  def icon
    :success
  end

  def actions
    %w[view_horse]
  end
end

