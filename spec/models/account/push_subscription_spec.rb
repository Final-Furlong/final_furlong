RSpec.describe Account::PushSubscription do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "#to_hash" do
    it "returns data as stringified hash" do
      subscription = create(:push_subscription)

      expect(subscription.to_hash).to eq({
        "endpoint" => subscription.endpoint,
        "keys" => {
          "auth" => subscription.auth_key,
          "p256dh" => subscription.p256dh_key
        }
      })
    end
  end
end

