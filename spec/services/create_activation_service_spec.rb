RSpec.describe CreateActivationService do
  subject(:migrate) { described_class.new(user.id) }

  let(:user) { create(:user, :pending) }

  context "when activation exists" do
    before { create(:activation, user:) }

    it "does not create an activation" do
      expect { migrate.call }.not_to change(Account::Activation, :count)
    end

    it "returns nil" do
      expect(migrate.call).to be_nil
    end
  end

  context "when activation does not exist" do
    it "creates an activation" do
      expect { migrate.call }.to change(Account::Activation, :count).by(1)
    end

    it "sets correct attributes on activation" do
      fake_token = SecureRandom.uuid
      allow(Digest::MD5).to receive(:hexdigest).with(user.email).and_return fake_token
      migrate.call

      expect(Account::Activation.last).to have_attributes(
        user:,
        token: fake_token,
        activated_at: nil
      )
    end

    it "returns user" do
      expect(migrate.call).to eq user
    end
  end
end

