require "rails_helper"

RSpec.describe CurrentStable::HorsePolicy do
  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(user, Horses::Horse.all).resolve
    end
    let(:stable) { build_stubbed(:stable) }
    let(:user) { stable.user }

    it "includes owned living horses" do
      scope = Horses::HorsesRepository.new.owned_by(stable)
      expected_scope = Horses::HorsesRepository.new(scope:).living

      expect(resolved_scope).to eq expected_scope
    end
  end
end

