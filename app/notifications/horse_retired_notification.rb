class HorseRetiredNotification < Notification
  def message
    I18n.t("notifications.horse_retired_notification.message", horse: params["horse_name"])
  end

  def title
    I18n.t("notifications.horse_retired_notification.title")
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

