FactoryBot.define do
  factory :racetrack do
    sequence(:name) { |n| "#{Faker::Company.name}_#{n}" }
    location
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end

# == Schema Information
#
# Table name: racetracks
#
#  id          :uuid             not null, primary key
#  latitude    :decimal(, )      not null, indexed
#  longitude   :decimal(, )      not null, indexed
#  name        :string           not null, indexed
#  created_at  :datetime         not null, indexed
#  updated_at  :datetime         not null
#  location_id :uuid             indexed
#
# Indexes
#
#  index_racetracks_on_created_at   (created_at)
#  index_racetracks_on_latitude     (latitude)
#  index_racetracks_on_location_id  (location_id)
#  index_racetracks_on_longitude    (longitude)
#  index_racetracks_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
