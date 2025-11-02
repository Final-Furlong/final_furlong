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
#
#  id              :bigint           not null, primary key
#  latitude        :decimal(, )      not null
#  longitude       :decimal(, )      not null
#  name            :string           not null, uniquely indexed
#  slug            :string           indexed
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location_id     :integer          indexed
#  old_id          :uuid             indexed
#  old_location_id :uuid             not null, indexed
#  public_id       :string(12)       indexed
#
# Indexes
#
#  index_racetracks_on_location_id      (location_id)
#  index_racetracks_on_name             (name) UNIQUE
#  index_racetracks_on_old_id           (old_id)
#  index_racetracks_on_old_location_id  (old_location_id)
#  index_racetracks_on_public_id        (public_id)
#  index_racetracks_on_slug             (slug)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id) ON DELETE => restrict ON UPDATE => cascade
#

