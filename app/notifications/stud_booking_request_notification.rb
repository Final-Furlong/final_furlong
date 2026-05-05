class StudBookingRequestNotification < Notification
  def message
    pd params
    # web    |             "mare_id" => "fine-art",
    # web    |             "message" => "my message",
    # web    |             "stud_id" => "beratis",
    # web    |           "mare_name" => "Fine Art",
    # web    |           "stud_name" => "Beratis",
    # web    |          "booking_id" => 2108,
    # web    |         "stable_name" => "Stillwater Farms",
    # web    |       "slot_end_date" => "Jun 30",
    # web    |     "slot_start_date" => "Jun 16"
    key = "notifications.stud_booking_request_notification.message"
    i18n_params = { stable: params["stable_name"], stud: params["stud_name"], mare: params["mare_name"], start: params["slot_start_date"], end: params["slot_end_date"] }
    if params["message"]
      key += "_with_comment"
      i18n_params[:comment] = params["message"]
    end
    I18n.t(key, **i18n_params)
  end

  def title
    I18n.t("notifications.stud_booking_request_notification.title")
  end

  def type
    :info
  end

  def actions
    %w[view_stud view_mare]
  end
end

