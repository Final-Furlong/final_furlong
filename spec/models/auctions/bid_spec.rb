RSpec.describe Auctions::Bid do
  describe "associations" do
    it { is_expected.to belong_to(:auction).class_name("::Auction") }
    it { is_expected.to belong_to(:horse).class_name("Auctions::Horse") }
    it { is_expected.to belong_to(:bidder).class_name("Account::Stable") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:current_bid) }
    it { is_expected.to validate_numericality_of(:current_bid).is_greater_than_or_equal_to(described_class::MINIMUM_BID) }

    describe "maximum bid" do
      it "can be blank" do
        bid = create(:auction_bid)
        expect(bid).to be_valid
      end

      it "cannot be less than current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 1001
        bid.maximum_bid = 1000
        expect(bid).not_to be_valid
      end

      it "can be equal to current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 1000
        bid.maximum_bid = 1000
        expect(bid).to be_valid
      end

      it "can be greater than current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 1000
        bid.maximum_bid = 1200
        expect(bid).to be_valid
      end
    end
  end

  describe "callbacks" do
    before do
      ActiveJob::Base.queue_adapter = :solid_queue
    end

    context "when bid is created" do
      it "enqueues the process auction sale job" do
        freeze_time
        bid = build(:auction_bid)
        expect do
          bid.save
        end.to change(SolidQueue::Job, :count).by(1)
        last_job = SolidQueue::Job.order(id: :desc).first
        job_arguments = last_job.arguments.deep_symbolize_keys[:arguments].first
        expect(job_arguments[:bid].values.first).to eq global_id_string(bid)
        expect(last_job.scheduled_at).to eq Time.current + bid.reload.auction.hours_until_sold.hours
      end

      context "when previous bid exists, with enqueued job" do
        it "replaces the process auction sale job" do
          freeze_time
          old_bid = create(:auction_bid)
          bid = build(:auction_bid, auction: old_bid.auction, horse: old_bid.horse, current_bid: old_bid.current_bid + 1000)
          expect { bid.save }.not_to change(SolidQueue::Job, :count)
          last_job = SolidQueue::Job.order(id: :desc).first
          job_arguments = last_job.arguments.deep_symbolize_keys[:arguments].first
          expect(job_arguments[:bid].values.first).to eq global_id_string(bid)
          expect(last_job.scheduled_at).to eq Time.current + bid.reload.auction.hours_until_sold.hours
        end
      end
    end

    context "when bid is updated" do
      it "replaces the process auction sale job" do # rubocop:disable RSpec/ExampleLength
        bid = last_job_id = nil
        travel_to 1.hour.ago do
          bid = create(:auction_bid)
          last_job_id = SolidQueue::Job.order(id: :desc).first.id
        end
        freeze_time
        bid.update(current_bid: 10_000)
        last_job = SolidQueue::Job.order(id: :desc).first
        expect(last_job.id).not_to eq last_job_id
        job_arguments = last_job.arguments.deep_symbolize_keys[:arguments].first
        expect(job_arguments[:bid].values.first).to eq global_id_string(bid)
        expect(last_job.scheduled_at).to eq Time.current + bid.reload.auction.hours_until_sold.hours
      end
    end

    context "when bid is destroyed" do
      it "deletes enqueued process auction sale job" do
        bid = create(:auction_bid)
        last_job = SolidQueue::Job.order(id: :desc).first
        expect do
          bid.destroy
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

