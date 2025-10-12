class Pwa::WebPushJob < ApplicationJob
  queue_as :default

  class InvalidSubscriptionError < StandardError; end

  attr_reader :subscription

  def perform(title:, message:, subscription:)
    @subscription = subscription
    message_json = {
      title:,
      body: message,
      icon: icon_url
    }.to_json

    endpoint = subscription_hash["endpoint"]
    keys = subscription_hash["keys"]
    response = WebPush.payload_send(
      message: message_json,
      endpoint:,
      p256dh: keys["p256dh"],
      auth: keys["auth"],
      vapid: {
        subject: vapid.subject,
        public_key: vapid.public_key,
        private_key: vapid.private_key
      }
    )

    logger.info "Web push sent to #{endpoint} with message: #{message.inspect}"
    logger.info "Web push response: #{response}"
  rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription
    subscription.destroy! if subscription.is_a?(Account::PushSubscription)
  rescue WebPush::ResponseError => response
    logger.error "WebPush: #{response.inspect}"
  end

  private

  def subscription_hash
    return subscription if subscription.is_a? Hash
    return subscription.to_hash if subscription.respond_to? :to_hash

    raise InvalidSubscriptionError.new("Cannot handle subscription type: #{subscription.class.name}")
  end

  def icon_url
    ActionController::Base.helpers.asset_url("app-icons/icon-192.png")
  end

  def vapid
    Rails.configuration.x.vapid
  end
end

