RSpec.describe Horses::LeaseTerminator do
  context "when terminator is the owner" do
    it "saves owner accept" do
      result = described_class.new.call(current_lease: lease, stable:
        owner, params: { owner_accepted_end: true })
      expect(result.created?).to be true
      expect(result.termination.owner_accepted_end).to be true
    end

    it "saves owner refund accept" do
      result = described_class.new.call(current_lease: lease, stable:
        owner, params: { owner_accepted_end: true, owner_accepted_refund: true })
      expect(result.created?).to be true
      expect(result.termination.owner_accepted_refund).to be true
    end

    context "when leaser has accepted end" do
      it "updates the lease" do
        lease.create_termination_request(leaser_accepted_end: true)
        expect do
          result = described_class.new.call(current_lease: lease, stable:
            owner, params: { owner_accepted_end: true })
          expect(result.terminated?).to be true
        end.not_to change(Account::Budget, :count)
        expect(lease.reload.early_termination_date).to eq Date.current
      end
    end

    context "when leaser has accepted refund" do
      it "processes refund" do
        lease.create_termination_request(leaser_accepted_end: true,
          leaser_accepted_refund: true)
        lease.update_columns(start_date: 6.months.ago, end_date: 6.months.from_now)
        expect do
          described_class.new.call(current_lease: lease, stable:
            owner, params: { owner_accepted_end: true, owner_accepted_refund:
            true })
        end.to change(Account::Budget, :count).by(2)
      end
    end

    context "when owner has not accepted" do
      it "does not save owner accept" do
        result = described_class.new.call(current_lease: lease, stable:
          owner, params: { owner_accepted_end: false })
        expect(result.created?).to be false
        expect(result.termination.owner_accepted_end).to be false
      end
    end
  end

  context "when terminator is the leaser" do
    it "saves leaser accept" do
      result = described_class.new.call(current_lease: lease, stable:
        leaser, params: { leaser_accepted_end: true })
      expect(result.created?).to be true
      expect(result.termination.leaser_accepted_end).to be true
    end

    it "saves leaser refund accept" do
      result = described_class.new.call(current_lease: lease, stable:
        leaser, params: { leaser_accepted_end: true, leaser_accepted_refund:
        true })
      expect(result.created?).to be true
      expect(result.termination.leaser_accepted_refund).to be true
    end

    context "when owner has accepted end" do
      it "updates the lease" do
        lease.create_termination_request(owner_accepted_end: true)
        expect do
          result = described_class.new.call(current_lease: lease, stable:
            leaser, params: { leaser_accepted_end: true })
          expect(result.terminated?).to be true
        end.not_to change(Account::Budget, :count)
        expect(lease.reload.early_termination_date).to eq Date.current
      end
    end

    context "when owner has accepted refund" do
      it "processes refund" do
        lease.create_termination_request(owner_accepted_end: true,
          owner_accepted_refund: true)
        lease.update_columns(start_date: 6.months.ago, end_date: 6.months.from_now)
        expect do
          described_class.new.call(current_lease: lease, stable:
            leaser, params: { leaser_accepted_end: true, leaser_accepted_refund:
            true })
        end.to change(Account::Budget, :count).by(2)
      end
    end

    context "when leaser has not accepted" do
      it "does not save leaser accept" do
        result = described_class.new.call(current_lease: lease, stable:
          leaser, params: { leaser_accepted_end: false })
        expect(result.created?).to be false
        expect(result.termination.leaser_accepted_end).to be false
      end
    end
  end

  private

  def lease
    @lease ||= create(:lease, horse:, fee: 10_000)
  end

  def horse
    @horse ||= create(:horse)
  end

  def owner
    @owner ||= horse.owner
  end

  def leaser
    @leaser ||= create(:stable)
  end
end

