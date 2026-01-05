module Racing
  class RacingStats < ApplicationRecord
    self.table_name = "racing_stats"

    include FlagShihTzu

    belongs_to :horse, class_name: "Horses::Horse"

    has_flags 1 => :blinkers,
      2 => :shadow_roll,
      3 => :wraps,
      4 => :figure_8,
      5 => :no_whip,
      :column => "desired_equipment"
  end
end

# == Schema Information
#
# Table name: racing_stats
# Database name: primary
#
#  id                     :bigint           not null, primary key
#  acceleration           :integer          default(0), not null
#  average_speed          :integer          default(0), not null
#  break_speed            :integer          default(0), not null
#  closing                :integer          default(0), not null
#  consistency            :integer          default(0), not null
#  courage                :integer          default(0), not null
#  desired_equipment      :integer          default(0), not null
#  dirt                   :integer          default(0), not null
#  energy                 :integer          default(0), not null
#  energy_minimum         :integer          default(0), not null
#  energy_regain          :integer          default(0), not null
#  fitness                :integer          default(0), not null
#  leading                :integer          default(0), not null
#  loaf_percent           :integer          default(0), not null
#  loaf_threshold         :integer          default(0), not null
#  max_speed              :integer          default(0), not null
#  midpack                :integer          default(0), not null
#  min_speed              :integer          default(0), not null
#  natural_energy_current :decimal(5, 3)    default(0.0), not null
#  natural_energy_gain    :decimal(5, 3)    default(0.0), not null
#  natural_energy_loss    :integer          default(0), not null
#  off_pace               :integer          default(0), not null
#  peak_end_date          :date             not null
#  peak_start_date        :date             not null
#  pissy                  :integer          default(0), not null
#  ratability             :integer          default(0), not null
#  soundness              :integer          default(0), not null
#  stamina                :integer          default(0), not null
#  steeplechase           :integer          default(0), not null
#  strides_per_second     :decimal(5, 3)    default(0.0), not null
#  sustain                :integer          default(0), not null
#  track_fast             :integer          default(0), not null
#  track_good             :integer          default(0), not null
#  track_slow             :integer          default(0), not null
#  track_wet              :integer          default(0), not null
#  traffic                :integer          default(0), not null
#  turf                   :integer          default(0), not null
#  turning                :integer          default(0), not null
#  weight                 :integer          default(0), not null
#  xp_current             :integer          default(0), not null
#  xp_rate                :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  horse_id               :bigint           not null, indexed
#
# Indexes
#
#  index_racing_stats_on_horse_id  (horse_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

