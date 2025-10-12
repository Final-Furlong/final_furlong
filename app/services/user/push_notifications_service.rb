class User::PushNotificationsService < ApplicationService
  attr_reader :user

  def call(user:, notification:)
    @user = user

    user.push_subscriptions.each do |subscription|
      Pwa::WebPushJob.perform_later(
        title: notification.title,
        message: notification.message,
        subscription:
      )
    end
  end
end

