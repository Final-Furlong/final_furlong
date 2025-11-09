class NotificationsController < ApplicationController
  def index
    @notifications = policy_scope(Notification, policy_scope_class: NotificationPolicy::Scope).order(created_at: :desc)
  end

  def update
    @notification = policy_scope(Notification, policy_scope_class: NotificationPolicy::Scope).find(params[:id])
    authorize @notification, policy_class: NotificationPolicy

    attrs = {}
    if notification_params[:read] == "true"
      attrs[:read_at] = DateTime.current
      status = I18n.t("notifications.notification.status.read")
    else
      attrs[:read_at] = nil
      status = I18n.t("notifications.notification.status.unread")
    end
    if @notification.update(attrs)
      flash[:success] = t(".success", status:)
      redirect_to root_path
    else
      flash[:error] = @notification.errors.full_messages.to_sentence
      redirect_to notifications_path
    end
  end

  def destroy
    @notification = policy_scope(Notification, policy_scope_class: NotificationPolicy::Scope).find(params[:id])
    authorize @notification, policy_class: NotificationPolicy

    if @notification&.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@notification) }
        format.html { redirect_to root_path, success: t(".success") }
      end
    else
      flash.now[:error] = t("common.error")
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@notification) }
        format.html { redirect_to notifications_path, error: t("common.error") }
      end
    end
  end

  private

  def notification_params
    params.expect(notification: [:read])
  end
end

