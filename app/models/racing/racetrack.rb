module Racing
  class Racetrack < ApplicationRecord
    belongs_to :location, inverse_of: :racetracks

    has_many :surfaces, class_name: "TrackSurface", dependent: :restrict_with_exception
    has_many :scheduled_races, through: :surfaces

    validates :name, presence: true, length: { minimum: 4 }
    validates :name, uniqueness: { case_sensitive: false }

    validates :longitude, presence: true,
      numericality: { less_than_or_equal_to: 180, greater_than_or_equal_to: -180 }
    validates :latitude, presence: true,
      numericality: { less_than_or_equal_to: 90, greater_than_or_equal_to: -90 }
  end
end

# == Schema Information
#
# Table name: racetracks
#
#  id          :uuid             not null, primary key
#  latitude    :decimal(, )      not null, indexed
#  longitude   :decimal(, )      not null, indexed
#  name        :string           not null
#  created_at  :datetime         not null, indexed
#  updated_at  :datetime         not null
#  location_id :uuid             not null, indexed
#
# Indexes
#
#  index_racetracks_on_created_at      (created_at)
#  index_racetracks_on_latitude        (latitude)
#  index_racetracks_on_location_id     (location_id)
#  index_racetracks_on_longitude       (longitude)
#  index_racetracks_on_lowercase_name  (lower((name)::text)) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#

