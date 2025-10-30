RSpec.shared_examples "a materialized view" do
  describe ".refresh" do
    it "triggers scenic refresh" do
      mock_database = instance_double(Scenic::Adapters::Postgres, refresh_materialized_view: true)
      allow(Scenic).to receive(:database).and_return mock_database

      described_class.refresh
      expect(mock_database).to have_received(:refresh_materialized_view)
    end
  end

  describe ".populated?" do
    it "checks scenic populated" do
      mock_database = instance_double(Scenic::Adapters::Postgres, populated?: true)
      allow(Scenic).to receive(:database).and_return mock_database

      described_class.populated?
      expect(mock_database).to have_received(:populated?)
    end
  end
end

