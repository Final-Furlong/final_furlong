require "rails_helper"

RSpec.describe FinalFurlong::Common::Validation::DateValidator do
  it "fails when date is nil" do
    model = set_model
    expect(model).not_to be_valid
    errors = date_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :date_invalid
    expect(errors.first.options).to eq({ value: nil })
  end

  it "fails when date is not a date" do
    model = set_model
    model.date = " "
    expect(model).not_to be_valid
    errors = date_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :date_invalid
    expect(errors.first.options).to eq({ value: " " })
  end

  it "fails when date is not a real date" do
    model = set_model
    model.date = "45/03/1956"
    expect(model).not_to be_valid
    errors = date_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :date_invalid
    expect(errors.first.options).to eq({ value: "45/03/1956" })
  end

  it "passes when date is a real date" do
    model = set_model
    model.date = "18/03/1956"
    expect(model).to be_valid
  end

  it "passes when date is today" do
    model = set_model
    model.date = Time.zone.today
    expect(model).to be_valid
  end

  it "passes with date allowing nil" do
    model = ModelWithDateValidationAllowingNil.new
    expect(model).to be_valid
  end

  it "passes with date allowing blank" do
    model = ModelWithDateValidationAllowingBlank.new(date: " ")
    expect(model).to be_valid
  end

  def set_model
    ModelWithDateValidation.new
  end

  def date_errors(model)
    model.errors.where(:date)
  end
end

class ModelWithDateField
  include ActiveModel::Model
  include FinalFurlong::Common::Validation

  attr_accessor :date
end

class ModelWithDateValidation < ModelWithDateField
  validates_date :date
end

class ModelWithDateValidationAllowingNil < ModelWithDateField
  validates_date :date, allow_nil: true
end

class ModelWithDateValidationAllowingBlank < ModelWithDateField
  validates_date :date, allow_blank: true
end

