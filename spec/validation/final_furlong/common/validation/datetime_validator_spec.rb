require "rails_helper"

RSpec.describe FinalFurlong::Common::Validation::DatetimeValidator do
  it "fails when datetime is nil" do
    model = set_model
    expect(model).not_to be_valid
    errors = date_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :datetime_invalid
    expect(errors.first.options).to eq({ value: nil })
  end

  it "fails when datetime is empty string" do
    model = set_model
    model.start_time = " "
    expect(model).not_to be_valid
    errors = date_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :datetime_invalid
    expect(errors.first.options).to eq({ value: " " })
  end

  it "fails when datetime is invalid date" do
    model = set_model
    model.start_time = "45/03/1956 14:35"
    expect(model).not_to be_valid
    errors = date_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :datetime_invalid
    expect(errors.first.options).to eq({ value: "45/03/1956 14:35" })
  end

  it "passes when datetime is a valid date" do
    model = set_model
    model.start_time = "18/03/1956"
    expect(model).to be_valid
  end

  it "passes when datetime is current time" do
    model = set_model
    model.start_time = Time.current
    expect(model).to be_valid
  end

  it "passes when nil is allowed" do
    model = ModelWithDatetimeValidationAllowingNil.new
    expect(model).to be_valid
  end

  it "passes when blank is allowed" do
    model = ModelWithDatetimeValidationAllowingBlank.new(start_time: " ")
    expect(model).to be_valid
  end

  def set_model
    ModelWithDatetimeValidation.new
  end

  def date_errors(model)
    model.errors.where(:start_time)
  end
end

class ModelWithDatetimeField
  include ActiveModel::Model
  include FinalFurlong::Common::Validation

  attr_accessor :start_time
end

class ModelWithDatetimeValidation < ModelWithDatetimeField
  validates_datetime :start_time
end

class ModelWithDatetimeValidationAllowingNil < ModelWithDatetimeField
  validates_datetime :start_time, allow_nil: true
end

class ModelWithDatetimeValidationAllowingBlank < ModelWithDatetimeField
  validates_datetime :start_time, allow_blank: true
end

