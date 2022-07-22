FactoryBot.define do
  factory :user do
    sequence(:username) do |n|
      "#{Faker::Internet.username(specifier: User::USERNAME_LENGTH - 1 - n.to_s.length)}_#{n}"
    end
    password { "Password1!" }
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
    end

    trait :banned do
      status { "banned" }
    end

    trait :unactivated do
      activation { association :activation, :unactivated }
    end

    trait :activated do
      activation { association :activation, :activated }
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
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
#  created_at             :datetime         not null, indexed
#  updated_at             :datetime         not null
#  discourse_id           :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_created_at            (created_at)
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_discourse_id          (discourse_id) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
