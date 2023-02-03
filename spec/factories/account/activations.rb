FactoryBot.define do
  factory :activation, class: "Account::Activation" do
    token { SecureRandom.uuid }
    user

    trait :unactivated do
      activated_at { nil }
    end

    trait :activated do
      activated_at { Time.current }
    end
  end
end

# == Schema Information
#
# Table name: activations
#
#  id           :bigint           not null, primary key
#  activated_at :datetime
#  token        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null, indexed
#
# Indexes
#
#  index_activations_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

