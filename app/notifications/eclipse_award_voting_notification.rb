class EclipseAwardVotingNotification < Notification
  def message
    I18n.t("notifications.eclipse_award_voting_notification.message", date: Date.current)
  end

  def title
    I18n.t("notifications.eclipse_award_voting_notification.title", year: params["year"], category: params["category_name"])
  end

  def type
    :info
  end

  def icon
    :info
  end

  def actions
    %w[view_voting]
  end
end

