require "rails_helper"

RSpec.describe FinalFurlong::Horses::Validation::NameValidator do
  describe "basic validator" do
    it "is valid when nil" do
      model = ModelWithDefaultHorseNameValidation.new

      expect(model).to be_valid
    end

    it "is valid when empty string" do
      model = ModelWithDefaultHorseNameValidation.new(name: "")

      expect(model).to be_valid
    end

    it "is not valid when name matches exactly" do
      horse = create(:horse)
      model = ModelWithDefaultHorseNameValidation.new(name: horse.name)

      expect(model).not_to be_valid
      errors = name_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :non_unique
    end

    it "is not valid when name matches on whitespace" do
      create(:horse, name: "Foo Bar")
      model = ModelWithDefaultHorseNameValidation.new(name: "FooBar")

      expect(model).not_to be_valid
      errors = name_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :non_unique
    end

    it "is not valid when name matches on single quote" do
      create(:horse, name: "Fo'o Bar")
      model = ModelWithDefaultHorseNameValidation.new(name: "FooBar")

      expect(model).not_to be_valid
      errors = name_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :non_unique
    end

    it "is not valid when name matches on ampersand" do
      create(:horse, name: "Foo & Bar")
      model = ModelWithDefaultHorseNameValidation.new(name: "Foo Bar")

      expect(model).not_to be_valid
      errors = name_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :non_unique
    end

    it "is not valid when name is Unnamed" do
      model = ModelWithDefaultHorseNameValidation.new(name: "Unnamed")

      expect(model).not_to be_valid
      errors = name_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :invalid
    end

    it "is not valid when name contains reserved words" do
      model = ModelWithDefaultHorseNameValidation.new(name: "My Final Furlong")

      expect(model).not_to be_valid
      errors = name_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :invalid
    end
  end

  private

  def name_errors(model)
    model.errors.where(:name)
  end
end

class ModelWithHorseNameField
  include ActiveModel::Model
  include FinalFurlong::Horses::Validation

  attr_accessor :name
end

class ModelWithDefaultHorseNameValidation < ModelWithHorseNameField
  validates_horse_name :name
end

class ModelWithHorseNameValidationAllowingNil < ModelWithHorseNameField
  validates_horse_name :name, allow_nil: true
end

class ModelWithHorseNameValidationAllowingBlank < ModelWithHorseNameField
  validates_horse_name :name, allow_blank: true
end
