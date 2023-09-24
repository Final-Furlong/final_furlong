RSpec.describe Stables::List do
  describe "#run" do
    it "fetches stables" do
      create(:stable)

      outcome = described_class.run
      expect(outcome.result).to eq Account::StablesQuery.new.ordered_by_name
    end
  end
end

