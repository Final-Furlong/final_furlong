# typed: false
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

  describe "associations" do
    it { is_expected.to have_one :stable }
  end

  describe "#slug_candidates" do
    it "sets slug based on name" do
      user = build(:user, name: "Bob User")

      expect do
        user.save
      end.to change { user.slug }.from(nil).to("bob-user")
    end

    it "falls back to discourse id" do
      create(:user, name: "Bob User", discourse_id: 1)
      user = build(:user, name: "Bob User", discourse_id: 2)

      expect do
        user.save
      end.to change { user.slug }.from(nil).to("bob-user-2")
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                         :bigint           not null, primary key
#  admin                                      :boolean          default(FALSE), not null
#  confirmation_sent_at                       :datetime
#  confirmation_token                         :string           indexed
#  confirmed_at                               :datetime
#  current_sign_in_at                         :datetime
#  current_sign_in_ip                         :string
#  email                                      :string           default(""), not null, indexed
#  encrypted_password                         :string           default(""), not null
#  failed_attempts                            :integer          default(0), not null
#  last_sign_in_at                            :datetime
#  last_sign_in_ip                            :string
#  locked_at                                  :datetime
#  name(displayed on profile)                 :string           not null
#  remember_created_at                        :datetime
#  reset_password_sent_at                     :datetime
#  reset_password_token                       :string           indexed
#  sign_in_count                              :integer          default(0), not null
#  slug                                       :string           indexed
#  status(pending, active, deleted, banned)   :enum             default("pending"), not null
#  unconfirmed_email                          :string
#  unlock_token                               :string           indexed
#  username                                   :string           not null, indexed
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  discourse_id(integer from Discourse forum) :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discourse_id          (discourse_id) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
