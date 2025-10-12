RSpec.describe UpdateLegacyBudgetsJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("low_priority")
    end

    context "when budgets exist" do
      it "triggers update code with max ID" do
        allow(MigrateLegacyBudgetsService).to receive(:new).and_return mock_service
        create(:budget, legacy_budget_id: 2)
        create(:budget, legacy_budget_id: 3)
        described_class.perform_later
        expect(MigrateLegacyBudgetsService).to have_received(:new).with(budget_id: 3, limit: 1000)
      end
    end

    context "when budget does not exist" do
      it "triggers update code with 0" do
        allow(MigrateLegacyBudgetsService).to receive(:new).and_return mock_service
        described_class.perform_later
        expect(MigrateLegacyBudgetsService).to have_received(:new).with(budget_id: 0, limit: 1000)
      end
    end
  end

  private

  def mock_service
    @mock_service ||= instance_double(MigrateLegacyBudgetsService, call: true)
  end
end

