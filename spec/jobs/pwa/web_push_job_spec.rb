require "ostruct"

RSpec.describe Pwa::WebPushJob, :perform_enqueueed_jobs do
  describe "#perform" do
    it "uses default queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later(title:, message:, subscription:)
      end.to have_enqueued_job.on_queue("default")
    end

    context "when web push does not error" do
      before { allow(WebPush).to receive(:payload_send).and_return true }

      it "triggers web push correctly" do
        described_class.perform_later(title:, message:, subscription:)

        expect(WebPush).to have_received(:payload_send).with(
          message: message_json(message),
          endpoint: subscription["endpoint"],
          p256dh: subscription["keys"]["p256dh"],
          auth: subscription["keys"]["auth"],
          vapid: { subject: vapid.subject, public_key: vapid.public_key, private_key: vapid.private_key }
        )
      end
    end

    context "when web push errors with expired subscription" do
      let(:error) { WebPush::ExpiredSubscription.new(OpenStruct.new(body: "expired"), "example.com") }

      before { allow(WebPush).to receive(:payload_send).and_raise error }

      it "does not error" do
        expect do
          described_class.perform_later(title:, message:, subscription:)
        end.not_to raise_error
      end

      context "when subscription is a push notification type" do
        it "does destroy the subscription" do
          push_subscription = create(:push_subscription, user:)
          described_class.perform_later(title:, message:, subscription: push_subscription)

          expect(Account::PushSubscription.exists?(id: push_subscription.id)).to be false
        end
      end
    end

    context "when web push errors with invalid subscription" do
      let(:error) { WebPush::InvalidSubscription.new(OpenStruct.new(body: "expired"), "example.com") }

      before { allow(WebPush).to receive(:payload_send).and_raise error }

      it "does not error" do
        expect do
          described_class.perform_later(title:, message:, subscription:)
        end.not_to raise_error
      end

      context "when subscription is a push notification type" do
        it "does destroy the subscription" do
          push_subscription = create(:push_subscription, user:)
          described_class.perform_later(title:, message:, subscription: push_subscription)

          expect(Account::PushSubscription.exists?(id: push_subscription.id)).to be false
        end
      end
    end

    context "when web push errors with other error" do
      let(:error) { WebPush::PushServiceError.new(OpenStruct.new(body: "expired"), "example.com") }

      before { allow(WebPush).to receive(:payload_send).and_raise error }

      it "does not error" do
        expect do
          described_class.perform_later(title:, message:, subscription:)
        end.not_to raise_error
      end

      context "when subscription is a push notification type" do
        it "does not destroy the subscription" do
          push_subscription = create(:push_subscription, user:)
          described_class.perform_later(title:, message:, subscription: push_subscription)

          expect(Account::PushSubscription.exists?(id: push_subscription.id)).to be true
        end
      end
    end

    context "when subscription is invalid" do
      it "errors" do
        expect do
          described_class.perform_later(title:, message:, subscription: "a subscription")
        end.to raise_error(described_class::InvalidSubscriptionError, "Cannot handle subscription type: String")
      end
    end
  end

  private

  def title
    @title ||= SecureRandom.alphanumeric(20)
  end

  def message
    @message ||= SecureRandom.alphanumeric(20)
  end

  def user
    @user ||= create(:user)
  end

  def subscription
    @subscription ||= {
      endpoint: "foo",
      keys: {
        p256dh: SecureRandom.alphanumeric(10),
        auth: SecureRandom.alphanumeric(10)
      }
    }.deep_stringify_keys
  end

  def vapid
    Rails.configuration.x.vapid
  end

  def message_json(message)
    {
      title:,
      body: message,
      icon: ActionController::Base.helpers.asset_url("app-icons/icon-192.png")
    }.to_json
  end
end

