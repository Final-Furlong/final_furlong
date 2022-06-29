# typed: false

FactoryBot.define do
  sequence(:discourse_id)

  factory :user do
    sequence(:username) do |n|
      "#{Faker::Internet.username(specifier: User::USERNAME_LENGTH - 1 - n.to_s.length)}_#{n}"
    end
    password { Faker::Internet.password(min_length: User::PASSWORD_LENGTH) }
    status { "active" }
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    admin { false }
    discourse_id
    confirmed_at { Time.current }
    stable { association :stable, user: instance }

    factory :admin do
      admin { true }
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
#  index_users_on_discourse_id          (discourse_id) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
