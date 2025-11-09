RSpec.describe Horses::Lease do
  describe "associations" do
    subject(:lease) { build_stubbed(:lease) }

    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to belong_to(:owner).class_name("Account::Stable") }
    it { is_expected.to belong_to(:leaser).class_name("Account::Stable") }

    it { is_expected.to have_one(:termination_request).class_name("Horses::LeaseTerminationRequest").dependent(:delete) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:fee) }

    describe "end date" do
      context "when horse is a racehorse" do
        it "can be 3-12 months" do
          lease = build(:lease, horse: create(:horse, :racehorse))
          (3...12).each do |months|
            lease.start_date = Date.current
            lease.end_date = Date.current + months.months
            expect(lease).to be_valid
          end
        end

        it "cannot be less than 3 months" do
          lease = build(:lease, horse: create(:horse, :racehorse))
          lease.start_date = Date.current
          lease.end_date = Date.current + 3.months - 1.day
          expect(lease).not_to be_valid
          expect(lease.errors[:end_date]).to eq(["must be greater than or equal to #{l(Date.current + 3.months)}"])
        end

        it "cannot be more than 1 year" do
          lease = build(:lease, horse: create(:horse, :racehorse))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year + 1.day
          expect(lease).not_to be_valid
          expect(lease.errors[:end_date]).to eq(["must be less than or equal to #{l(Date.current + 1.year)}"])
        end
      end

      context "when horse is a stud" do
        it "can be 12 months" do
          lease = build(:lease, horse: create(:horse, :stallion))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year
          expect(lease).to be_valid
        end

        it "cannot be less than 1 year" do
          lease = build(:lease, horse: create(:horse, :stallion))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year - 1.day
          expect(lease).not_to be_valid
          expect(lease.errors[:end_date]).to eq(["must be greater than or equal to #{l(Date.current + 1.year)}"])
        end

        it "cannot be more than 1 year" do
          lease = build(:lease, horse: create(:horse, :stallion))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year + 1.day
          expect(lease).not_to be_valid
          expect(lease.errors[:end_date]).to eq(["must be less than or equal to #{l(Date.current + 1.year)}"])
        end
      end

      context "when horse is a broodmare" do
        it "can be 12 months" do
          lease = build(:lease, horse: create(:horse, :broodmare))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year
          expect(lease).to be_valid
        end

        it "cannot be less than 1 year" do
          lease = build(:lease, horse: create(:horse, :broodmare))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year - 1.day
          expect(lease).not_to be_valid
          expect(lease.errors[:end_date]).to eq(["must be greater than or equal to #{l(Date.current + 1.year)}"])
        end

        it "cannot be more than 1 year" do
          lease = build(:lease, horse: create(:horse, :broodmare))
          lease.start_date = Date.current
          lease.end_date = Date.current + 1.year + 1.day
          expect(lease).not_to be_valid
          expect(lease.errors[:end_date]).to eq(["must be less than or equal to #{l(Date.current + 1.year)}"])
        end
      end
    end
  end

  describe "#total_days" do
    it "returns the difference in days from start to end" do
      lease = build(:lease, start_date: Date.current, end_date: Date.current + 90.days)
      expect(lease.total_days).to eq 90
    end
  end
end

