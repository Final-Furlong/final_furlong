module Racing
  class TrackSurface < ApplicationRecord
    belongs_to :racetrack

    validates :surface, :condition, :width, :length, :turn_to_finish_length,
      :turn_distance, :banking, :jumps, presence: true
  end
end

# == Schema Information
#
# Table name: track_surfaces
#
#  id                    :uuid             not null, primary key
#  banking               :integer          not null
#  condition             :enum             default("fast"), not null
#  jumps                 :integer          default(0), not null
#  length                :integer          not null
#  surface               :enum             default("dirt"), not null
#  turn_distance         :integer          not null
#  turn_to_finish_length :integer          not null
#  width                 :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  racetrack_id          :uuid             not null, indexed
#
# Indexes
#
#  index_track_surfaces_on_racetrack_id  (racetrack_id)
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id)
#

