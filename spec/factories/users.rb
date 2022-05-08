# frozen_string_literal: true

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
FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    status { "active" }
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    admin { false }
    sequence(:discourse_id) { |n| n }

    factory :admin do
      admin { true }
    end
  end
end
