RSpec.describe Horses::Appearance do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
  end

  describe "validations" do
    subject(:appearance) { build_stubbed(:horse_appearance) }

    it { is_expected.to validate_presence_of(:birth_height) }
    it { is_expected.to validate_presence_of(:color) }
    it { is_expected.to validate_presence_of(:current_height) }
    it { is_expected.to validate_presence_of(:max_height) }

    it "validates current height vs birth height" do
      appearance.max_height = 11
      appearance.current_height = 10
      appearance.birth_height = 5
      expect(appearance).to be_valid

      appearance.current_height = 4
      expect(appearance).not_to be_valid
    end

    it "has check constraint for current height vs birth height" do
      # rubocop:disable Rails/SkipsModelValidations
      appearance = create(:horse_appearance)
      expect do
        appearance.update_columns(current_height: 10, max_height: 11, birth_height: 5)
      end.not_to raise_error

      expect do
        appearance.update_columns(current_height: 10, max_height: 20, birth_height: 15)
      end.to raise_error ActiveRecord::StatementInvalid, /current_height_must_be_valid/
      # rubocop:enable Rails/SkipsModelValidations
    end

    it "validates max height vs current height" do
      appearance.max_height = 11
      appearance.current_height = 10
      appearance.birth_height = 5
      expect(appearance).to be_valid

      appearance.max_height = 9
      expect(appearance).not_to be_valid
    end

    it "has check constraint for max height vs current height" do
      # rubocop:disable Rails/SkipsModelValidations
      appearance = create(:horse_appearance)
      expect do
        appearance.update_columns(current_height: 10, max_height: 11, birth_height: 5)
      end.not_to raise_error

      expect do
        appearance.update_columns(current_height: 10, max_height: 5, birth_height: 5)
      end.to raise_error ActiveRecord::StatementInvalid, /max_height_must_be_valid/
      # rubocop:enable Rails/SkipsModelValidations
    end

    it { is_expected.to validate_inclusion_of(:color).in_array(Horses::Color::VALUES.keys.map(&:to_s)) }
    it { is_expected.to validate_inclusion_of(:rf_leg_marking).in_array(Horses::LegMarking::VALUES.keys.map(&:to_s)) }
    it { is_expected.to validate_inclusion_of(:lf_leg_marking).in_array(Horses::LegMarking::VALUES.keys.map(&:to_s)) }
    it { is_expected.to validate_inclusion_of(:lh_leg_marking).in_array(Horses::LegMarking::VALUES.keys.map(&:to_s)) }
    it { is_expected.to validate_inclusion_of(:rh_leg_marking).in_array(Horses::LegMarking::VALUES.keys.map(&:to_s)) }

    it "validates RF image" do
      appearance.rf_leg_marking = nil
      appearance.rf_leg_image = nil
      expect(appearance).to be_valid

      appearance.rf_leg_marking = Horses::LegMarking::VALUES.keys.sample.to_s
      expect(appearance).not_to be_valid
      appearance.rf_leg_image = "image.png"
      expect(appearance).to be_valid
    end

    it "validates RH image" do
      appearance.rh_leg_marking = nil
      appearance.rh_leg_image = nil
      expect(appearance).to be_valid

      appearance.rh_leg_marking = Horses::LegMarking::VALUES.keys.sample.to_s
      expect(appearance).not_to be_valid
      appearance.rh_leg_image = "image.png"
      expect(appearance).to be_valid
    end

    it "validates LF image" do
      appearance.lf_leg_marking = nil
      appearance.lf_leg_image = nil
      expect(appearance).to be_valid

      appearance.lf_leg_marking = Horses::LegMarking::VALUES.keys.sample.to_s
      expect(appearance).not_to be_valid
      appearance.lf_leg_image = "image.png"
      expect(appearance).to be_valid
    end

    it "validates LH image" do
      appearance.lh_leg_marking = nil
      appearance.lh_leg_image = nil
      expect(appearance).to be_valid

      appearance.lh_leg_marking = Horses::LegMarking::VALUES.keys.sample.to_s
      expect(appearance).not_to be_valid
      appearance.lh_leg_image = "image.png"
      expect(appearance).to be_valid
    end
  end
end

