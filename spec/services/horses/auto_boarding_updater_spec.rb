RSpec.describe Horses::AutoBoardingUpdater do
  describe "#call" do
    it "ends boarding for horses who started 30 days ago" do
      allow(Horses::BoardingUpdater).to receive(:new).and_return mock_updater
      boarding = create(:boarding, start_date: 30.days.ago, end_date: nil, days: 0)

      described_class.new.call

      expect(mock_updater).to have_received(:stop_boarding).with(boarding:).at_least(:once)
    end

    it "ends boarding for horses who have reached 30 days total this year" do
      travel_to Date.new(Date.current.year, 3, 1) do
        allow(Horses::BoardingUpdater).to receive(:new).and_return mock_updater
        old_boarding = create(:boarding, horse:, start_date: 50.days.ago, end_date: 30.days.ago, days: 20)
        boarding = create(:boarding, horse:, start_date: 10.days.ago, end_date: nil, location: old_boarding.location)
        described_class.new.call
        expect(mock_updater).to have_received(:stop_boarding).with(boarding:)
      end
    end

    it "does not ends boarding for horses who have not reached 30 days total this year" do
      travel_to Date.new(Date.current.year, 3, 1) do
        allow(Horses::BoardingUpdater).to receive(:new).and_return mock_updater
        old_boarding = create(:boarding, horse:, start_date: 50.days.ago, end_date: 40.days.ago, days: 10)
        boarding = create(:boarding, horse:, start_date: 10.days.ago, end_date: nil, location: old_boarding.location)
        described_class.new.call
        expect(mock_updater).not_to have_received(:stop_boarding).with(boarding:)
      end
    end

    it "decrements stable balance for all un-ended boarded horses" do
      stable = horse.owner
      _boarding = create(:boarding, horse:, start_date: 5.days.ago, end_date: nil)
      _boarding2 = create(:boarding, horse: create(:horse, owner: stable), start_date: 10.days.ago, end_date: nil)
      _ended_boarding = create(:boarding, horse: create(:horse, owner: stable), start_date: 10.days.ago, end_date: 5.days.ago, days: 5)
      stable.update(total_balance: 10_000, available_balance: 8_500)
      described_class.new.call
      expect(stable.reload.available_balance).to eq 8_300
    end
  end

  private

  def mock_updater
    @mock_updater ||= instance_double(Horses::BoardingUpdater, stop_boarding: true)
  end

  def horse
    @horse ||= create(:horse)
  end
end

