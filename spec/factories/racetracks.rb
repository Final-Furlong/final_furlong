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
#  id         :uuid             not null, primary key
#  country    :string           not null, indexed
#  latitude   :decimal(, )      not null, indexed
#  longitude  :decimal(, )      not null, indexed
#  name       :string           not null, indexed
#  state      :string
#  created_at :datetime         not null, indexed
#  updated_at :datetime         not null
#
# Indexes
#
#  index_racetracks_on_country     (country)
#  index_racetracks_on_created_at  (created_at)
#  index_racetracks_on_latitude    (latitude)
#  index_racetracks_on_longitude   (longitude)
#  index_racetracks_on_name        (name) UNIQUE
#
