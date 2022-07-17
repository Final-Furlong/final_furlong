RSpec.describe User, type: :model do
  describe "callbacks" do
    describe "#before_validation" do
      it "sets status to pending" do
        user = build(:user, :without_stable, status: nil)

        expect { user.valid? }.to change(user, :status).from(nil).to("pending")
      end

      it "sets admin to false" do
        user = build(:user, :without_stable, admin: nil)

        expect { user.valid? }.to change(user, :admin).from(nil).to(false)
      end

      it "does not override pre-set values" do
        user = build(:admin, :without_stable, status: "banned")

        expect { user.valid? }.not_to change { user }
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_one :stable }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string           indexed
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discarded_at           :datetime         indexed
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  slug                   :string           indexed
#  status                 :enum             default("pending"), not null
#  unconfirmed_email      :string
#  unlock_token           :string           indexed
#  username               :string           not null, indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  discourse_id           :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_discourse_id          (discourse_id) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
