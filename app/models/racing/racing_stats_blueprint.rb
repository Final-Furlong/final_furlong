module Racing
  class RacingStatsBlueprint < Blueprinter::Base
    identifier :horse_id

    fields :break_speed, :min_speed, :average_speed, :max_speed, :stamina, :sustain,
      :consistency, :track_fast, :track_good, :track_wet, :track_slow, :dirt, :turf,
      :steeplechase, :courage, :peak_start_date, :peak_end_date, :leading, :off_pace,
      :midpack, :closing, :soundness, :fitness, :pissy, :ratability, :desired_equipment,
      :strides_per_second, :loaf_threshold, :loaf_percent, :acceleration, :traffic,
      :energy, :energy_regain, :natural_energy_current, :natural_energy_loss,
      :xp_current, :xp_rate, :turning, :weight
  end
end

