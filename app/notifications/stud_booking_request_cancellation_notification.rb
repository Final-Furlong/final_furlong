class StudBookingRequestCancellationNotification < Notification
  def message
    key = "notifications.stud_booking_request_cancellation_notification.message"
    i18n_params = { stable: params["stable_name"], stud: params["stud_name"], mare: params["mare_name"], start: params["slot_start_date"], end: params["slot_end_date"] }
    I18n.t(key, **i18n_params)
  end

  def title
    I18n.t("notifications.stud_booking_request_cancellation_notification.title")
  end

  def type
    :error
  end

  def actions
    %w[view_stud view_mare]
  end
end

