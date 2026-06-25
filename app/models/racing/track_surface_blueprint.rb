module Racing
  class TrackSurfaceBlueprint < Blueprinter::Base
    identifier :id

    fields :surface, :racetrack_id, :condition, :banking, :jumps,
      :length, :turn_distance, :turn_to_finish_length, :width

    field :track_name do |surface, options|
      surface.racetrack.name
    end
  end
end

# == Schema Information
#
# Table name: track_surfaces
# Database name: primary
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
#  racetrack_id                      :bigint           not null, uniquely indexed => [surface]
#
# Indexes
#
#  index_track_surfaces_on_racetrack_id_and_surface  (racetrack_id,surface) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id) ON DELETE => cascade ON UPDATE => cascade
#

