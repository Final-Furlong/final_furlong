require_relative "../../shared/scenic_examples"

RSpec.describe Racing::AnnualRaceRecord do
  it_behaves_like "a materialized view"

  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse").inverse_of(:annual_race_records) }
  end
end

