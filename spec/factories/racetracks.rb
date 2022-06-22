# typed: false

FactoryBot.define do
  factory :racetrack do
    sequence(:name) { |n| "#{Faker::Company.name}_#{n}" }
    state { Faker::Address.state }
    country { Faker::Address.country }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end

# == Schema Information
#
# Table name: racetracks
#
#  id         :bigint           not null, primary key
#  country    :string           indexed
#  latitude   :decimal(, )      indexed
#  longitude  :decimal(, )      indexed
#  name       :string           indexed
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_racetracks_on_country    (country)
#  index_racetracks_on_latitude   (latitude)
#  index_racetracks_on_longitude  (longitude)
#  index_racetracks_on_name       (name) UNIQUE
#
