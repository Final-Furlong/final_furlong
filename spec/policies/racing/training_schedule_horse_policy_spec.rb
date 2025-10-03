require "rails_helper"

RSpec.describe Racing::TrainingScheduleHorsePolicy do
  subject(:policy) { described_class.new(user, horse) }

  let(:user) { build_stubbed(:user) }
  let(:horse) { build_stubbed(:training_schedule_horse) }

  context "when user is a visitor" do
    let(:user) { nil }

    it "does not allow anything" do
      expect(policy).not_to permit_actions(:index, :create)
    end
  end

  context "when user is logged in and matches horse" do
    let(:user) { create(:user) }
    let(:schedule) { create(:training_schedule, stable: user.stable) }
    let(:racehorse) { create(:horse, owner: user.stable) }
    let(:horse) { build(:training_schedule_horse, training_schedule: schedule, horse: racehorse) }

    it "allows index" do
      expect(policy).to permit_actions(:index)
    end

    it "allows create" do
      expect(policy).to permit_actions(:create)
    end

    context "when horse already exists in schedule" do
      it "does not allow create" do
        create(:training_schedule_horse, training_schedule: schedule, horse: racehorse)
        expect(policy).not_to permit_actions(:create)
      end
    end
  end
end

