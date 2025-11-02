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
#  id                                :bigint           not null, primary key
#  banking                           :integer          not null
#  condition(fast, good, slow, wet)  :enum             default("fast"), not null
#  jumps                             :integer          default(0), not null
#  length                            :integer          not null
#  surface(dirt, turf, steeplechase) :enum             default("dirt"), not null
#  turn_distance                     :integer          not null
#  turn_to_finish_length             :integer          not null
#  width                             :integer          not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  old_id                            :uuid             indexed
#  old_racetrack_id                  :uuid             not null, indexed
#  racetrack_id                      :integer          indexed
#
# Indexes
#
#  index_track_surfaces_on_old_id            (old_id)
#  index_track_surfaces_on_old_racetrack_id  (old_racetrack_id)
#  index_track_surfaces_on_racetrack_id      (racetrack_id)
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id) ON DELETE => cascade ON UPDATE => cascade
#

