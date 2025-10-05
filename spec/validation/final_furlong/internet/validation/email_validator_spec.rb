RSpec.describe FinalFurlong::Internet::Validation::EmailValidator do
  describe "validating password strength" do
    it "fails when nil" do
      model = set_model
      expect(model).not_to be_valid
      errors = email_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :invalid
    end

    it 'fails when " "' do
      model = set_model
      model.email = " "
      expect(model).not_to be_valid
      errors = email_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :invalid
    end

    it 'fails when "abc"' do
      model = set_model
      model.email = "abc"
      expect(model).not_to be_valid
      errors = email_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :invalid
    end

    it 'fails when "abc1@"' do
      model = set_model
      model.email = "abc1@"
      expect(model).not_to be_valid
      errors = email_errors(model)

      expect(errors.count).to eq 1
      expect(errors.last.type).to eq :invalid
    end

    it "fails when too long" do
      model = set_model
      model.email = "#{"a" * 64}@#{"a" * 186}.com"
      expect(model).not_to be_valid
      errors = email_errors(model)

      expect(errors.count).to eq 1
      expect(errors.last.type).to eq :too_long
      expect(errors.first.options).to eq({ count: 254 })
    end

    it 'passes when "abc1@abc2.com"' do
      model = set_model
      model.email = "abc1@abc2.com"
      expect(model).to be_valid
    end
  end

  describe "validating email allowing nil" do
    it "is valid when nil" do
      nil_model = ModelWithEmailValidationAllowingNil.new
      nil_model.email = nil
      expect(nil_model).to be_valid
    end
  end

  describe "validating email allowing blank" do
    it "is valid when blank" do
      blank_model = ModelWithEmailValidationAllowingBlank.new
      blank_model.email = "   "
      expect(blank_model).to be_valid
    end
  end

  private

  def set_model
    ModelWithDefaultEmailValidation.new
  end

  def email_errors(model)
    model.errors.where(:email)
  end
end

class ModelWithDefaultEmailField
  include ActiveModel::Model
  include FinalFurlong::Internet::Validation

  attr_accessor :email
end

class ModelWithDefaultEmailValidation < ModelWithDefaultEmailField
  validates_email :email
end

class ModelWithEmailValidationAllowingNil < ModelWithDefaultEmailField
  validates_email :email, allow_nil: true
end

class ModelWithEmailValidationAllowingBlank < ModelWithDefaultEmailField
  validates_email :email, allow_blank: true
end

