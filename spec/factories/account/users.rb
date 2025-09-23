FactoryBot.define do
  factory :user, class: "Account::User" do
    sequence(:username) do |n|
      "#{Faker::Internet.username(specifier: Account::User::USERNAME_LENGTH - 1 - n.to_s.length)}_#{n}"
    end
    password { "abc1A$ab" }
    status { "active" }
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    admin { false }
    discourse_id { rand(1..999_999) }
    confirmed_at { Time.current }
    stable { association :stable, user: instance }

    trait :without_stable do
      stable { nil }
    end

    factory :admin do
      admin { true }
    end

    trait :pending do
      status { "pending" }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :deleted do
      status { "deleted" }
      discarded_at { Time.current }
    end

    trait :banned do
      status { "banned" }
    end

    trait :unactivated do
      activation { association :activation, :unactivated }
      status { "pending" }
    end

    trait :activated do
      activation { association :activation, :activated }
      status { "active" }
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                         :uuid             not null, primary key
#  admin                                      :boolean          default(FALSE), not null
#  confirmation_sent_at                       :datetime
#  confirmation_token                         :string           uniquely indexed
#  confirmed_at                               :datetime
#  current_sign_in_at                         :datetime
#  current_sign_in_ip                         :string
#  discarded_at                               :datetime         indexed
#  email                                      :string           default(""), not null, uniquely indexed
#  encrypted_password                         :string           default(""), not null
#  failed_attempts                            :integer          default(0), not null
#  last_sign_in_at                            :datetime
#  last_sign_in_ip                            :string
#  locked_at                                  :datetime
#  name                                       :string           not null
#  remember_created_at                        :datetime
#  reset_password_sent_at                     :datetime
#  reset_password_token                       :string           uniquely indexed
#  sign_in_count                              :integer          default(0), not null
#  slug                                       :string           uniquely indexed
#  status(pending, active, deleted, banned)   :enum             default("pending"), not null
#  unconfirmed_email                          :string
#  unlock_token                               :string           uniquely indexed
#  username                                   :string           not null
#  created_at                                 :datetime         not null, indexed
#  updated_at                                 :datetime         not null
#  discourse_id(integer from Discourse forum) :integer          uniquely indexed
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_created_at            (created_at) WHERE (discarded_at IS NULL)
#  index_users_on_discarded_at          (discarded_at) WHERE (discarded_at IS NULL)
#  index_users_on_discourse_id          (discourse_id) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_email                 (email) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_lowercase_username    (lower((username)::text)) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_slug                  (slug) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_unlock_token          (unlock_token) UNIQUE WHERE (discarded_at IS NULL)
#

