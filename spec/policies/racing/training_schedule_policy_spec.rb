require "rails_helper"

RSpec.describe Racing::TrainingSchedulePolicy do
  subject(:policy) { described_class.new(schedule, user:) }

  let(:user) { build_stubbed(:user) }
  let(:schedule) { build_stubbed(:training_schedule) }

  describe "relation scope" do
    subject(:scope) { policy.apply_scope(Racing::TrainingSchedule.all, type: :active_record_relation) }

    it "includes born horses" do
      expect(scope).to eq Racing::TrainingSchedulesQuery.new.with_stable(user.stable).ordered
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "does not allow anything" do
      expect(policy).not_to allow_actions(:new, :edit, :destroy, :view_horses)
    end
  end

  context "when user is logged in and matches schedule" do
    let(:user) { create(:user) }
    let(:schedule) { create(:training_schedule, stable: user.stable) }

    it "allows main actions" do
      expect(policy).to allow_actions(:edit, :destroy, :view_horses)
    end

    context "when stable does not have max schedules" do
      it "allows new" do
        expect(policy).to allow_actions(:new)
      end
    end

    context "when stable has max schedules" do
      it "does not allow new" do
        (Racing::TrainingSchedule::MAX_SCHEDULES_PER_STABLE - 1).times do
          create(:training_schedule, stable: user.stable)
        end

        expect(policy).not_to allow_actions(:new)
      end
    end
  end

  context "when user is logged in and does not matches schedule" do
    let(:user) { create(:user) }
    let(:schedule) { create(:training_schedule, stable: create(:stable)) }

    it "disallows main actions" do
      expect(policy).not_to allow_actions(:edit, :destroy, :view_horses)
    end
  end
end

