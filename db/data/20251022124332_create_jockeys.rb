class CreateJockeys < ActiveRecord::Migration[8.0]
  def up
    Legacy::Jockey.find_each do |legacy_jockey|
      jockey = Racing::Jockey.find_or_initialize_by(first_name: legacy_jockey.First, last_name: legacy_jockey.Last)
      attrs = {
        legacy_id: legacy_jockey.ID,
        date_of_birth: legacy_jockey.DOB,
        height_in_inches: legacy_jockey.Height,
        weight: legacy_jockey.Weight,
        strength: legacy_jockey.Strength,
        acceleration: legacy_jockey.Acceleration,
        break_speed: legacy_jockey.Break,
        min_speed: legacy_jockey.Min,
        average_speed: legacy_jockey.Ave,
        max_speed: legacy_jockey.Max,
        leading: legacy_jockey.Lead,
        midpack: legacy_jockey.Midpack,
        off_pace: legacy_jockey.Pace,
        closing: legacy_jockey.Close,
        consistency: legacy_jockey.Consistency,
        courage: legacy_jockey.Courage,
        pissy: legacy_jockey.Pissy,
        rating: legacy_jockey.Rating,
        dirt: legacy_jockey.Dirt,
        turf: legacy_jockey.Turf,
        steeplechase: legacy_jockey.SC,
        fast: legacy_jockey.Fast,
        good: legacy_jockey.Good,
        slow: legacy_jockey.Slow,
        wet: legacy_jockey.Wet,
        turning: legacy_jockey.Turning,
        looking: legacy_jockey.Looking,
        traffic: legacy_jockey.Traffic,
        loaf_threshold: legacy_jockey.LoafThresh,
        whip_seconds: legacy_jockey.WhipSec,
        experience: legacy_jockey.XPCurrent,
        experience_rate: legacy_jockey.XPRate
      }
      attrs[:gender] = (legacy_jockey.Gender == "M") ? "male" : "female"
      attrs[:status] = case legacy_jockey.Status.to_i
      when 1 then "apprentice"
      when 2 then "veteran"
      when 3 then "retired"
      end
      attrs[:jockey_type] = (legacy_jockey.Height <= 60) ? "flat" : "jump"
      jockey.update(attrs)
    end
  end

  def down
    Racing::Jockey.delete_all
    raise ActiveRecord::IrreversibleMigration
  end
end

