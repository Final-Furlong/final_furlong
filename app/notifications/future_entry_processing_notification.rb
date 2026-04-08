class FutureEntryProcessingNotification < Notification
  def message
    I18n.t("notifications.future_entry_processing_notification.message", date: I18n.l(date), entered: entered_text, errored: errored_text, skipped: skipped_text)
  end

  def entered_text
    I18n.t("notifications.future_entry_processing_notification.entered_horses", count: params["succeeded"])
  end

  def errored_text
    I18n.t("notifications.future_entry_processing_notification.errored_horses", count: params["errored"])
  end

  def skipped_text
    I18n.t("notifications.future_entry_processing_notification.skipped_horses", count: params["skipped"])
  end

  def title
    I18n.t("notifications.future_entry_processing_notification.title")
  end

  def date
    params["date"].is_a?(Date) ? params["date"] : Date.parse(params["date"])
  end

  def type
    :info
  end

  def actions
    %w[view_future_entries]
  end
end

