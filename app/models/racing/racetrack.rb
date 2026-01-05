module Racing
  class Racetrack < ApplicationRecord
    include PublicIdGenerator
    include FriendlyId

    friendly_id :name, use: [:slugged, :finders]

    belongs_to :location, inverse_of: :racetrack

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

