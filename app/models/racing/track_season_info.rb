module Racing
  class TrackSeasonInfo < ApplicationRecord
    self.table_name = "track_season_info"

    belongs_to :location

    validates :season, presence: true
    validates :season, uniqueness: { case_sensitive: false, scope: :location_id }
    validate :max_chance

    private

    def max_chance
      return if (fast_chance + good_chance + wet_chance + slow_chance) == 100

      errors.add(:base, :invalid)
    end
  end
end

# == Schema Information
#
# Table name: track_season_info
# Database name: primary
#
#  id          :bigint           not null, primary key
#  fast_chance :integer          default(0)
#  good_chance :integer          default(0)
#  season      :enum             not null, uniquely indexed => [location_id]
#  slow_chance :integer          default(0)
#  wet_chance  :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint           not null, uniquely indexed => [season]
#
# Indexes
#
#  index_track_season_info_on_location_id_and_season  (location_id,season) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#

