require "rails_helper"

RSpec.describe FinalFurlong::Internet::Validation::UrlValidator do
  it "fails when url is nil" do
    model = set_model
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: model.url })
  end

  it "fails when url is empty string" do
    model = set_model
    model.url = " "
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: model.url })
  end

  it "fails when url is domain without scheme" do
    model = set_model
    model.url = "www.finalfurlong.org"
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: model.url })
  end

  it "passes when url is http domain" do
    model = set_model
    model.url = "http://www.finalfurlong.org"
    expect(model).to be_valid
  end

  it "passes when url is https domain" do
    model = set_model
    model.url = "https://www.finalfurlong.org"
    expect(model).to be_valid
  end

  it "fails when url is domain by ftp" do
    model = set_model
    model.url = "ftp://www.finalfurlong.org"
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: model.url })
  end

  it "passes when url is at max length" do
    model = set_model
    model.url = "https://www.finalfurlong.org?param=#{'a' * 1965}"  # this is exactly 2000 characters
    expect(model).to be_valid
  end

  it "fails when url is over max length" do
    model = set_model
    model.url = "https://www.finalfurlong.org?param=#{'a' * 1966}"
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :too_long
    expect(errors.first.options).to eq({ count: 2000 })
  end

  it "fails custom scheme with blank url" do
    model = ModelWithCustomSchemesValidation.new
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: nil })
  end

  it "fails custom scheme with invalid ftp url" do
    model = ModelWithCustomSchemesValidation.new(url: "ftp.finalfurlong.org")
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: "ftp.finalfurlong.org" })
  end

  it "fails custom scheme with invalid ftp/http url" do
    model = ModelWithCustomSchemesValidation.new(url: "http://ftp.finalfurlong.org")
    expect(model).not_to be_valid
    errors = url_errors(model)

    expect(errors.count).to eq 1
    expect(errors.first.type).to eq :invalid
    expect(errors.first.options).to eq({ value: "http://ftp.finalfurlong.org" })
  end

  it "passes custom scheme with valid ftp url" do
    model = ModelWithCustomSchemesValidation.new(url: "ftp://ftp.finalfurlong.org")
    expect(model).to be_valid
  end

  it "passes custom scheme with valid sftp url" do
    model = ModelWithCustomSchemesValidation.new(url: "sftp://ftp.finalfurlong.org")
    expect(model).to be_valid
  end

  it "validates url allowing nil" do
    model = ModelWithAllowingNil.new
    assert model.valid?
  end

  it "validates url allowing blank" do
    model = ModelWithAllowingBlank.new(url: " ")
    assert model.valid?
  end

  private

  def set_model
    ModelWithHttpValidation.new
  end

  def url_errors(model)
    model.errors.where(:url)
  end
end

class SampleModel
  include ActiveModel::Model
  include FinalFurlong::Internet::Validation

  attr_accessor :url
end

class ModelWithHttpValidation < SampleModel
  validates_url :url
end

class ModelWithCustomSchemesValidation < SampleModel
  validates_url :url, schemes: %w[ftp sftp]
end

class ModelWithAllowingNil < SampleModel
  validates_url :url, allow_nil: true
end

class ModelWithAllowingBlank < SampleModel
  validates_url :url, allow_blank: true
end
