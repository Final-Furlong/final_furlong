RSpec.describe FinalFurlong::Internet::Validation::PasswordValidator do
  describe "validating password strength" do
    it "fails when nil" do
      model = set_model
      expect(model).not_to be_valid
      errors = password_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :weak
    end

    it 'fails when " "' do
      model = set_model
      model.password = " "
      expect(model).not_to be_valid
      errors = password_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :too_short
      expect(errors.first.options).to eq({ count: 8 })
    end

    it 'fails when "abc"' do
      model = set_model
      model.password = "abc"
      expect(model).not_to be_valid
      errors = password_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :too_short
      expect(errors.first.options).to eq({ count: 8 })
    end

    it 'fails when "abc1abcd"' do
      model = set_model
      model.password = "abc1abcd"
      expect(model).not_to be_valid
      errors = password_errors(model)

      expect(errors.count).to eq 1
      expect(errors.last.type).to eq :weak
    end

    it 'fails when "abc1Aabc"' do
      model = set_model
      model.password = "abc1Aabc"
      expect(model).not_to be_valid
      errors = password_errors(model)

      expect(errors.count).to eq 1
      expect(errors.last.type).to eq :weak
    end

    it 'fails when "abc1A$a"' do
      model = set_model
      model.password = "abc1A$a"
      expect(model).not_to be_valid
      errors = password_errors(model)

      expect(errors.count).to eq 1
      expect(errors.first.type).to eq :too_short
      expect(errors.first.options).to eq({ count: 8 })
    end

    it 'passes when "abc1A$ab"' do
      model = set_model
      model.password = "abc1A$ab"
      expect(model).to be_valid
    end
  end

  describe "validating password allowing nil" do
    it "is valid when nil" do
      nil_model = ModelWithPasswordValidationAllowingNil.new
      nil_model.password = nil
      expect(nil_model).to be_valid
    end
  end

  describe "validating password allowing blank" do
    it "is valid when blank" do
      blank_model = ModelWithPasswordValidationAllowingBlank.new
      blank_model.password = "   "
      expect(blank_model).to be_valid
    end
  end

  private

  def set_model
    ModelWithDefaultPasswordValidation.new
  end

  def password_errors(model)
    model.errors.where(:password)
  end
end

class ModelWithPasswordField
  include ActiveModel::Model
  include FinalFurlong::Internet::Validation

  attr_accessor :password
end

class ModelWithDefaultPasswordValidation < ModelWithPasswordField
  validates_password :password
end

class ModelWithPasswordValidationAllowingNil < ModelWithPasswordField
  validates_password :password, allow_nil: true
end

class ModelWithPasswordValidationAllowingBlank < ModelWithPasswordField
  validates_password :password, allow_blank: true
end

