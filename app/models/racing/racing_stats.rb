module Racing
  class RacingStats < ApplicationRecord
    self.table_name = "racing_stats"

    include FlagShihTzu

    belongs_to :horse, class_name: "Horses::Horse"

    validates :acceleration, :average_speed, :break_speed, :closing,
      :consistency, :courage, :desired_equipment, :dirt, :energy,
      :energy_minimum, :energy_regain, :fitness, :leading, :loaf_percent,
      :loaf_threshold, :max_speed, :midpack, :min_speed,
      :natural_energy_current, :natural_energy_gain, :natural_energy_loss,
      :off_pace, :peak_end_date, :peak_start_date, :pissy, :ratability,
      :soundness, :stamina, :steeplechase, :strides_per_second,
      :sustain, :track_fast, :track_good, :track_slow, :track_wet,
      :traffic, :turf, :turning, :weight, :xp_current, :xp_rate,
      presence: true

    has_flags 1 => :blinkers,
      2 => :shadow_roll,
      3 => :wraps,
      4 => :figure_8,
      5 => :no_whip,
      :column => "desired_equipment"

    def peak_percent
      if Date.current < peak_start_date
        # 1. Count days from birthdate to 1/1/2yo year (x)
        days_to_two_year_old = (Date.new(horse.date_of_birth.year + 2, 1, 1) -
                               horse.date_of_birth).to_i
        # 2. Count days from birthdate to peak start date (y)
        days_to_peak_start = (peak_start_date - horse.date_of_birth).to_i
        # 3. Count days from birthdate to now (z)
        current_days_old = (Date.current - horse.date_of_birth).to_i
        # 4. y - x = days into immaturity
        days_toward_peak = days_to_peak_start - days_to_two_year_old
        # 5. z - x = total immaturity range
        total_peak_days = current_days_old - days_to_two_year_old
        # 6. days until peak / days past 2yo start = a%
        percent_towards_peak = total_peak_days.fdiv(days_toward_peak).round(2)
        # 7. a% x 40% (90% - 50%) = b%
        total_percent = percent_towards_peak * 0.4
        # 8. 60% + b% = final %
        0.6 + total_percent
      elsif Date.current > peak_end_date
        # 1. Count total days of peak time (y)
        total_peak_length = (peak_end_date - peak_start_date).to_i
        # 2. Count time since peak ended = days past peak (a)
        days_past_peak = (Date.current - peak_end_date).to_i
        # 3. a / y = b%
        percent_past_peak = 1 - days_past_peak.fdiv(total_peak_length).round(2)
        # 4. b% of 80% (100% - 20%) = c%
        total_percent = percent_past_peak * 0.8
        # 5. 100% - c% = final %
        1 + total_percent
      else
        # 1. Count days from birthdate to imm. date (x)
        days_to_peak_start = (peak_start_date - horse.date_of_birth).to_i
        # 2. Count days from birthdate to hb. date (y)
        days_to_peak_end = (peak_end_date - horse.date_of_birth).to_i
        # 3. Count days from birthdate to now (z)
        current_days_old = (Date.current - horse.date_of_birth).to_i
        # 4. Calculate days for halfway pt of peak range (a)
        halfway_through_peak = days_to_peak_start + ((peak_end_date - peak_start_date).to_i / 2)
        days_into_peak = if current_days_old < halfway_through_peak
          current_days_old - days_to_peak_start
        else
          days_to_peak_end - current_days_old
        end
        # 6c. days toward hb / a = b%
        percent_into_peak = days_into_peak.fdiv(halfway_through_peak).round(2)
        # 6d. 100% - b% = c%
        total_percent = 1 - percent_into_peak
        # 6e. c% of 10% (110% - 10%) = d%
        total_percent *= percent_into_peak # 0.1
        # 6f. 100% + d% = final %
        1 + total_percent
      end
    end
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
#  horse_id               :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_racing_stats_on_horse_id  (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

