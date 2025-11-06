RSpec.describe Horses::BoardingUpdator do
  describe "#stop_boarding" do
    context "when boarding has already ended" do
      before { boarding.update(start_date: 5.days.ago, end_date: 2.days.ago, days: 3) }

      it "does not modify boarding" do
        expect do
          described_class.new.stop_boarding(boarding:)
        end.not_to change(boarding, :reload)
      end

      it "returns error" do
        result = described_class.new.stop_boarding(boarding:)
        expect(result.error).to eq i18n("already_ended")
      end
    end

    context "when horse is leased" do
      before do
        legacy_horse.update(Leased: 1, leaser: leaser.legacy_id)
      end

      it "creates budget entry for leasing stable" do
        expect do
          described_class.new.stop_boarding(boarding:)
        end.to change(Account::Budget, :count).by(1)
        expect(Account::Budget.last.stable).to eq leaser
      end
    end

    context "when horse is not leased" do
      it "creates budget entry for owner" do
        expect do
          described_class.new.stop_boarding(boarding:)
        end.to change(Account::Budget, :count).by(1)
        expect(Account::Budget.last.stable).to eq horse.owner
      end
    end

    it "updates boarding end date" do
      expect do
        described_class.new.stop_boarding(boarding:)
      end.to change(boarding, :end_date).from(nil).to(Date.current)
    end

    it "updates boarding days" do
      expect do
        described_class.new.stop_boarding(boarding:)
      end.to change(boarding, :days).from(0).to(5)
    end

    it "returns updated true" do
      result = described_class.new.stop_boarding(boarding:)
      expect(result.updated?).to be true
    end

    context "when boarding duration is 0 days" do
      before { boarding.update(start_date: Date.current) }

      it "does not create budget entry" do
        expect do
          described_class.new.stop_boarding(boarding:)
        end.not_to change(Account::Budget, :count)
      end

      it "deletes boarding entry" do
        expect do
          described_class.new.stop_boarding(boarding:)
        end.to change(Horses::Boarding, :count).by(-1)
        expect(Horses::Boarding.exists?(id: boarding.id)).to be false
      end

      it "returns updated true" do
        result = described_class.new.stop_boarding(boarding:)
        expect(result.updated?).to be true
      end
    end

    context "when boarding duration is 1 day" do
      it "creates correct description" do
        boarding.update(start_date: Date.current - 1.day)
        described_class.new.stop_boarding(boarding:)

        budget = Account::Budget.last
        expect(budget.description).to end_with("for 1 day")
      end
    end

    context "when boarding duration is 5 days" do
      it "creates correct description" do
        described_class.new.stop_boarding(boarding:)

        budget = Account::Budget.last
        expect(budget.description).to end_with("for 5 days")
      end
    end
  end

  private

  def horse
    @horse ||= create(:horse, legacy_id: legacy_horse.ID)
  end

  def legacy_horse
    @legacy_horse ||= create(:legacy_horse)
  end

  def leaser
    @leaser ||= create(:stable, legacy_id: 100)
  end

  def boarding
    @boarding ||= create(:boarding, horse:, start_date: Date.current - 5.days, end_date: nil, days: 0)
  end

  def i18n(key)
    I18n.t("services.boarding.updator.#{key}")
  end
end

