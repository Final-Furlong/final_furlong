require "rails_helper"

RSpec.describe Users::NewUserForm, type: :model do
  describe "validation" do
    subject(:form) { described_class.new(User.new) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }

    it "validates unique username" do
      pending("hook this up")
      user1 = create(:user)
      user = build(:user, username: user1.username)
      expect(described_class.new(user)).to validate_uniqueness_of(:username).case_insensitive
    end

    it "validates unique email" do
      pending("hook this up")
      user1 = create(:user)
      user = build(:user, email: user1.email)
      expect(described_class.new(user)).to validate_uniqueness_of(:email).case_insensitive
    end
  end
end
