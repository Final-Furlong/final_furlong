require "rails_helper"

RSpec.describe HorsePolicy do
  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(User.new, Horse.all).resolve
    end

    it "includes living horses" do
      expect(resolved_scope).to eq Horse.living
    end
  end
end

