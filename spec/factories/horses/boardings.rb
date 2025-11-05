FactoryBot.define do
  factory :boarding, class: "Horses::Boarding" do
    horse
    location
    start_date { Date.current }

    trait :current do
      start_date { 1.day.ago }
      end_date { nil }
      days { 1 }
    end

    trait :past do
      start_date { 60.days.ago }
      end_date { 30.days.ago }
      days { 30 }
    end
  end
end

# == Schema Information
#
# Table name: boardings
# Database name: primary
#
#  id          :uuid             not null, primary key
#  days        :integer          default(0), not null
#  end_date    :date             indexed
#  start_date  :date             not null, uniquely indexed => [horse_id, location_id], indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  horse_id    :bigint           not null, indexed, uniquely indexed => [location_id, start_date]
#  location_id :bigint           not null, uniquely indexed => [horse_id, start_date], indexed
#
# Indexes
#
#  index_boardings_on_end_date                                 (end_date)
#  index_boardings_on_horse_id                                 (horse_id)
#  index_boardings_on_horse_id_and_location_id_and_start_date  (horse_id,location_id,start_date) UNIQUE
#  index_boardings_on_location_id                              (location_id)
#  index_boardings_on_start_date                               (start_date)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (location_id => locations.id)
#

