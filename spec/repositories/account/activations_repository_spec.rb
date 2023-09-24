RSpec.describe Account::ActivationsRepository do
  subject(:repo) { described_class.new(model: Account::Activation) }

  describe "#find_by!" do
    context "when matching token exists" do
      it "returns matching activation" do
        matching_activation = create(:activation)
        _non_matching_activation = create(:activation)

        result = repo.find_by!(token: matching_activation.token)
        expect(result).to eq matching_activation
      end
    end

    context "when matching token does not exist" do
      it "raises error" do
        expect { repo.find_by!(token: "foo") }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "#activate!" do
    let(:user) { create(:user, :unactivated) }
    let(:activation) { user.activation }

    it "updates user status" do
      expect { repo.activate!(activation) }.to change(user.reload, :status).to("active")
    end

    it "updates activation timestamp" do
      freeze_time do
        expect { repo.activate!(activation) }.to change(activation.reload, :activated_at).to Time.current
      end
    end
  end
end

