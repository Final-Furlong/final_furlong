FactoryBot.define do
  factory :horse_sale, class: "Horses::Sale" do
    horse
    seller { horse.owner }
    buyer { association :stable }
    price { 10_000 }
    date { Date.current }

    trait :public do
      private { false }
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
#  horse_id    :bigint           not null, uniquely indexed => [location_id, start_date]
#  location_id :bigint           not null, uniquely indexed => [horse_id, start_date], indexed
#
# Indexes
#
#  index_boardings_on_end_date                                 (end_date)
#  index_boardings_on_horse_id_and_location_id_and_start_date  (horse_id,location_id,start_date) UNIQUE
#  index_boardings_on_location_id                              (location_id)
#  index_boardings_on_start_date                               (start_date)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (location_id => locations.id)
#

