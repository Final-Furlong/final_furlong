class HorseBornNotification < Notification
  def message
    if params["created"]
      I18n.t("notifications.horse_born_notification.message_created")
    else
      I18n.t("notifications.horse_born_notification.message", sire:
        params["sire_name"], dam: params["dam_name"])
    end
  end

  def title
    name = params["created"] ? I18n.t("horse.created") : params["dam_name"]
    I18n.t("notifications.horse_born_notification.title", mare: name)
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

