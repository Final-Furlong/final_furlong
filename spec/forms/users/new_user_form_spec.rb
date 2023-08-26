require "rails_helper"

RSpec.describe Users::NewUserForm, type: :model do
  describe "validation" do
    subject(:form) { described_class.new(Account::User.new) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
    it { is_expected.to validate_presence_of(:stable_name) }
    it { is_expected.to validate_length_of(:username).is_at_least(Account::User::USERNAME_LENGTH) }
    it { is_expected.to validate_length_of(:password).is_at_least(Account::User::PASSWORD_LENGTH) }

    it "validates unique username" do
      user1 = create(:user)
      form = described_class.new(Account::User.new)
      form.submit(user_attrs.merge(username: user1.username.upcase))

      expect(form).not_to be_valid
      expect(form.errors[:username]).to eq(["has already been taken"])
    end

    it "validates unique email" do
      user1 = create(:user)
      form = described_class.new(Account::User.new)
      form.submit(user_attrs.merge(email: user1.email.upcase))

      expect(form).not_to be_valid
      expect(form.errors[:email]).to eq(["has already been taken"])
    end

    it "validates weak password" do
      form = described_class.new(Account::User.new)
      form.submit(user_attrs.merge(password: "password", password_confirmation: "password"))

      expect(form).not_to be_valid
      expect(form.errors[:password]).to eq(["must be at least 8 characters long and contain: " \
                                            "an upper case character, a lower case character, " \
                                            "a digit and a non-alphabet character."])
    end
  end

  private

  def user_attrs
    attrs = attributes_for(:user)
    {
      name: attrs[:name],
      email: attrs[:email],
      password: attrs[:password],
      password_confirmation: attrs[:password],
      username: attrs[:username],
      stable_name: attributes_for(:stable)[:name]
    }
  end
end

