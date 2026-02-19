class HorseStillbornNotification < Notification
  def message
    I18n.t("notifications.horse_stillborn_notification.message", sire:
      params["sire_name"], dam: params["dam_name"])
  end

  def title
    I18n.t("notifications.horse_stillborn_notification.title", mare: params["dam_name"])
  end

  def type
    :error
  end

  def icon
    :error
  end

  def actions
    %w[view_horse]
  end
end

