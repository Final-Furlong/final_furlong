class User::SendDeveloperNotifications < ApplicationService
  attr_reader :title, :message

  def call(title:, message:)
    @title = title
    @message = message
    Account::User.developer.where.associated(:push_subscriptions).uniq.each do |user|
      user.push_subscriptions.each do |subscription|
        Pwa::WebPushJob.perform_later(title:, message:, subscription: subscription.to_hash)
      end
    end
  end
end

