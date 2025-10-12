require "ostruct"

RSpec.describe User::PushNotificationsService do
  before { ActiveJob::Base.queue_adapter = :test }

  describe "#call" do
    it "loops through push notifications and triggers job for each" do
      push_subscriptions
      described_class.call(user:, notification:)
      expect(Pwa::WebPushJob).to have_been_enqueued.exactly(number_of_subscriptions).times
    end

    it "passes subscription into fo job" do
      push_subscriptions
      described_class.call(user:, notification:)
      push_subscriptions.each do |subscription|
        expect(Pwa::WebPushJob).to have_been_enqueued.with(
          title: notification.title,
          message: notification.message,
          subscription:
        )
      end
    end
  end

  private

  def notification
    @notification ||= OpenStruct.new(
      title: SecureRandom.alphanumeric(10),
      message: SecureRandom.alphanumeric(20)
    )
  end

  def user
    @user ||= create(:user)
  end

  def push_subscriptions
    @push_subscriptions ||= create_list(:push_subscription, number_of_subscriptions, user:)
  end

  def number_of_subscriptions
    3
  end
end

