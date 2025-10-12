RSpec.describe User::SendDeveloperNotifications do
  before { ActiveJob::Base.queue_adapter = :test }

  describe "#call" do
    context "when dev users exist" do
      it "sends notification to all subscriptions for devs" do
        sub
        dev2 = create(:user, :developer)
        create_list(:push_subscription, 2, user: dev2)

        _dev3 = create(:user, :developer)
        _non_dev = create(:user)

        described_class.call(title:, message:)
        expect(Pwa::WebPushJob).to have_been_enqueued.exactly(3).times
      end

      it "sends hashed subscription" do
        sub
        described_class.call(title:, message:)
        expect(Pwa::WebPushJob).to have_been_enqueued.with(
          title:, message:, subscription: {
            endpoint: sub.endpoint,
            keys: { p256dh: sub.p256dh_key, auth: sub.auth_key }
          }.deep_stringify_keys
        )
      end
    end
  end

  private

  def dev1
    @dev1 ||= create(:user, :developer)
  end

  def sub
    @sub ||= create(:push_subscription, user: dev1)
  end

  def title
    @title ||= SecureRandom.alphanumeric(10)
  end

  def message
    @message ||= SecureRandom.alphanumeric(20)
  end
end

