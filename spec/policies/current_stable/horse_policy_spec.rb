require "rails_helper"

RSpec.describe CurrentStable::HorsePolicy do
  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(user, Horse.all).resolve
    end
    let(:stable) { build_stubbed(:stable) }
    let(:user) { stable.user }

    it "includes owned living horses" do
      expect(resolved_scope).to eq Horse.owned_by(stable).living
    end
  end
end

