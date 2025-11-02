module Racing
  class TrackSurface < ApplicationRecord
    self.ignored_columns += ["old_id", "old_racetrack_id"]

    CONDITIONS = %w[fast good slow wet].freeze

    belongs_to :racetrack

    has_many :scheduled_races, class_name: "RaceSchedule", dependent: :restrict_with_exception
    has_many :completed_races, class_name: "RaceResult", dependent: :restrict_with_exception

    validates :surface, :condition, :width, :length, :turn_to_finish_length,
              :turn_distance, :banking, :jumps, presence: true
    validates :condition, inclusion: { in: CONDITIONS }
    validates :surface, uniqueness: { scope: :racetrack_id }

    scope :dirt, -> { where(surface: "dirt") }
    scope :turf, -> { where(surface: "turf") }
    scope :steeplechase, -> { where(surface: "steeplechase") }
  end
end

# == Schema Information
#
# Table name: track_surfaces
#
#  id                                :bigint           not null, primary key
#  banking                           :integer          not null
#  condition(fast, good, slow, wet)  :enum             default("fast"), not null
#  jumps                             :integer          default(0), not null
#  length                            :integer          not null
#  surface(dirt, turf, steeplechase) :enum             default("dirt"), not null, uniquely indexed => [racetrack_id]
#  turn_distance                     :integer          not null
#  turn_to_finish_length             :integer          not null
#  width                             :integer          not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  old_id                            :uuid             indexed
#  old_racetrack_id                  :uuid             not null, indexed
#  racetrack_id                      :bigint           not null, uniquely indexed => [surface]
#
# Indexes
#
#  index_track_surfaces_on_old_id                    (old_id)
#  index_track_surfaces_on_old_racetrack_id          (old_racetrack_id)
#  index_track_surfaces_on_racetrack_id_and_surface  (racetrack_id,surface) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id) ON DELETE => cascade ON UPDATE => cascade
#

