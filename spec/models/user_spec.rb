# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "callbacks" do
    describe "#before_validation" do
      it "sets status to pending" do
        user = build(:user, status: nil)

        expect { user.valid? }.to change(user, :status).from(nil).to("pending")
      end

      it "sets admin to false" do
        user = build(:user, admin: nil)

        expect { user.valid? }.to change(user, :admin).from(nil).to(false)
      end

      it "does not override pre-set values" do
        user = build(:admin, status: "banned")

        expect { user.valid? }.not_to change { user }
      end
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:discourse_id).on(:activate) }

    it "validates unique username" do
      user1 = create(:user)
      user = build(:user, username: user1.username)
      expect(user).to validate_uniqueness_of(:username).case_insensitive
    end

    it "validates unique email" do
      user1 = create(:user)
      user = build(:user, email: user1.email)
      expect(user).to validate_uniqueness_of(:email).case_insensitive
    end

    it "validates unique discourse id" do
      user1 = create(:user)
      user = build(:user, discourse_id: user1.discourse_id)
      expect(user).to validate_uniqueness_of(:discourse_id).on(:activate)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  admin        :boolean          default(FALSE), not null
#  email        :string           not null
#  name         :string           not null
#  status       :enum             default("pending"), not null
#  username     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  discourse_id :integer
#
# Indexes
#
#  index_users_on_discourse_id  (discourse_id) UNIQUE
#  index_users_on_email         (email) UNIQUE
#  index_users_on_username      (username) UNIQUE
#
