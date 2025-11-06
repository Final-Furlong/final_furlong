FactoryBot.define do
  factory :racetrack, class: "Racing::Racetrack" do
    sequence(:name) { |n| "#{Faker::Company.name}_#{n}" }
    location
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end

# == Schema Information
#
# Table name: racetracks
# Database name: primary
#
#  id          :bigint           not null, primary key
#  latitude    :decimal(, )      not null
#  longitude   :decimal(, )      not null
#  name        :string           not null
#  slug        :string           indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint           not null, uniquely indexed
#  public_id   :string(12)       indexed
#
# Indexes
#
#  index_racetracks_on_location_id  (location_id) UNIQUE
#  index_racetracks_on_name         (lower((name)::text)) UNIQUE
#  index_racetracks_on_public_id    (public_id)
#  index_racetracks_on_slug         (slug)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id) ON DELETE => restrict ON UPDATE => cascade
#

