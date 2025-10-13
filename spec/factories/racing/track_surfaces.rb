FactoryBot.define do
  factory :track_surface, class: "Racing::TrackSurface" do
    banking { 4 }
    condition { "fast" }
    jumps { 0 }
    length { 2500 }
    surface { "dirt" }
    turn_distance { 1000 }
    turn_to_finish_length { 1000 }
    width { 100 }
    racetrack
  end
end

# == Schema Information
#
# Table name: track_surfaces
#
#  id                                :uuid             not null, primary key
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
#  racetrack_id                      :uuid             not null, uniquely indexed => [surface]
#
# Indexes
#
#  index_track_surfaces_on_racetrack_id_and_surface  (racetrack_id,surface) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id)
#

