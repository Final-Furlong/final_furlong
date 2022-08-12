FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location_#{n}" }
    state { Faker::Address.state }
    country { Faker::Address.country }
  end
end

# == Schema Information
#
# Table name: locations
#
#  id         :uuid             not null, primary key
#  country    :string           not null
#  county     :string
#  name       :string           not null
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

