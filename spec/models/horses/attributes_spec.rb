RSpec.describe Horses::Attributes do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:title).in_array(described_class::TITLES).allow_blank }
  end

  describe "#title_string" do
    it "works for all titles" do
      described_class::TITLES.each do |title|
        expected_value = (title == "Normal") ? "Champion" : "#{title} Champion"

        result = described_class.new(title:)
        expect(result.title_string).to eq expected_value
      end
    end
  end

  describe "#title_abbr" do
    it "works for all titles" do
      described_class::TITLES.each do |title|
        prefix = (title == "Normal") ? "" : title.split(" ").map { |word| word[0] }.join.upcase
        expected_value = "#{prefix}Ch."

        result = described_class.new(title:)
        expect(result.title_abbr).to eq expected_value
      end
    end
  end
end

