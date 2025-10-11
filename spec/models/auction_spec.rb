RSpec.describe Auction do
  describe "associations" do
    it { is_expected.to belong_to(:auctioneer).class_name("Account::Stable") }
    it { is_expected.to have_many(:horses).class_name("Auctions::Horse").dependent(:destroy) }
    it { is_expected.to have_many(:bids).class_name("Auctions::Bid").dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :start_time }
    it { is_expected.to validate_presence_of :end_time }
    it { is_expected.to validate_presence_of :hours_until_sold }
    it { is_expected.to validate_numericality_of(:horse_purchase_cap_per_stable).only_integer.is_greater_than(0).allow_nil }
    it { is_expected.to validate_numericality_of(:hours_until_sold).only_integer.is_greater_than_or_equal_to(12).is_less_than_or_equal_to(48).allow_nil }
    it { is_expected.to validate_numericality_of(:spending_cap_per_stable).only_integer.is_greater_than_or_equal_to(10_000).allow_nil }

    describe "start time" do
      it "must be more than minimum delay days away" do
        auction = build(:auction, start_time: Date.current)

        expect(auction).not_to be_valid
        expect(auction.errors[:start_time].size).to eq 1
        expect(auction.errors[:start_time].first).to include "must be greater than or equal to #{(Date.current + described_class::MINIMUM_DELAY.days).to_date}"
        auction.start_time = Date.current + described_class::MINIMUM_DELAY.days
        expect(auction).to be_valid
      end
    end

    describe "end time" do
      it "must be more than minimum duration days away" do
        auction = build(:auction)
        start_time = auction.start_time
        auction.end_time = start_time + 1.day

        expect(auction).not_to be_valid
        expect(auction.errors[:end_time].size).to eq 1
        expect(auction.errors[:end_time].first).to include "must be greater than or equal to #{(start_time.to_date + described_class::MINIMUM_DURATION.days).to_date}"
        auction.end_time = start_time + described_class::MINIMUM_DURATION.days
        expect(auction).to be_valid
      end

      it "must be less than maximum duration days away" do
        auction = build(:auction)
        start_time = auction.start_time
        auction.end_time = start_time + (described_class::MAXIMUM_DURATION + 1).days

        expect(auction).not_to be_valid
        expect(auction.errors[:end_time].size).to eq 1
        expect(auction.errors[:end_time].first).to include "must be less than or equal to #{(start_time.to_date + described_class::MAXIMUM_DURATION.days).to_date}"
        auction.end_time = start_time + described_class::MAXIMUM_DURATION.days
        expect(auction).to be_valid
      end
    end

    describe "status" do
      it "requires at least one status to be picked" do
        auction = build(:auction)
        auction.broodmare_allowed = false
        auction.racehorse_allowed_2yo = false
        auction.racehorse_allowed_3yo = false
        auction.racehorse_allowed_older = false
        auction.stallion_allowed = false
        auction.weanling_allowed = false
        auction.yearling_allowed = false

        expect(auction).not_to be_valid
        expect(auction.errors[:base]).to eq([t("activerecord.errors.models.auction.attributes.base.status_required")])
      end
    end

    # validate :minimum_status_required
  end

  describe "callbacks" do
    before do
      ActiveJob::Base.queue_adapter = :solid_queue
    end

    context "when auction is created" do
      it "enqueues the auction deletion job" do
        freeze_time
        auction = build(:auction)
        expect do
          auction.save
        end.to change(SolidQueue::Job, :count).by(1)
        last_job = SolidQueue::Job.order(id: :desc).first
        job_arguments = last_job.arguments.deep_symbolize_keys[:arguments].first
        expect(job_arguments[:auction].values.first).to eq global_id_string(auction)
        expect(last_job.scheduled_at).to eq auction.end_time + 1.minute
      end
    end

    context "when auction is updated" do
      it "replaces the auction deletion job" do # rubocop:disable RSpec/ExampleLength
        auction = last_job_id = nil
        travel_to 1.hour.ago do
          auction = create(:auction)
          last_job_id = SolidQueue::Job.order(id: :desc).first.id
        end
        freeze_time
        auction.update(end_time: auction.start_time + 9.days)
        last_job = SolidQueue::Job.order(id: :desc).first
        expect(last_job.id).not_to eq last_job_id
        job_arguments = last_job.arguments.deep_symbolize_keys[:arguments].first
        expect(job_arguments[:auction].values.first).to eq global_id_string(auction)
        expect(last_job.scheduled_at).to eq auction.reload.end_time + 1.minute
      end
    end

    context "when auction is destroyed" do
      it "deletes enqueued auction deletion job" do
        auction = create(:auction)
        last_job = SolidQueue::Job.order(id: :desc).first
        expect do
          auction.destroy
        end.to change(SolidQueue::Job, :count).by(-1)
        expect(SolidQueue::Job.exists?(id: last_job.id)).to be false
      end
    end
  end

  private

  def global_id_string(object)
    object.to_global_id.to_s
  end
end

