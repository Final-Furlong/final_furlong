RSpec.describe Horses::NameUpdater do
  context "when name is valid" do
    it "returns updated" do
      result = described_class.new.change_name(horse:, params:)
      expect(result.updated?).to be true
    end

    it "returns no error" do
      result = described_class.new.change_name(horse:, params:)
      expect(result.error).to be_nil
    end

    it "updates horse" do
      expect do
        described_class.new.change_name(horse:, params:)
      end.to change(horse, :name).to(params[:name])
    end

    it "updates legacy horse" do
      described_class.new.change_name(horse:, params:)
      expect(legacy_horse.reload.Name).to eq params[:name]
      expect(legacy_horse.slug).to eq horse.reload.slug
    end
  end

  context "when name is invalid" do
    it "returns updated false" do
      result = described_class.new.change_name(horse:, params: invalid_params)
      expect(result.updated?).to be false
    end

    it "returns error" do
      result = described_class.new.change_name(horse:, params: invalid_params)
      expect(result.error).to eq "Name is too long (maximum is 18 characters)"
    end

    it "does not modify horse" do
      expect do
        described_class.new.change_name(horse:, params: invalid_params)
      end.not_to change(horse, :reload)
    end

    it "does not modify legacy horse" do
      expect do
        described_class.new.change_name(horse:, params: invalid_params)
      end.not_to change(legacy_horse, :reload)
    end
  end

  private

  def params
    { name: "New Name" }
  end

  def invalid_params
    { name: "New Name xxxxxxxxxx" }
  end

  def horse
    @horse ||= create(:horse, name: "Old Name", legacy_id: legacy_horse.ID)
  end

  def legacy_horse
    @legacy_horse ||= create(:legacy_horse, name: "Old Horse", slug: "old-horse")
  end
end

