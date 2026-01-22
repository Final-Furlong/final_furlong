class UpdateLegacyRacingStatsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Horses::Horse.where("date_of_birth != date_of_death").where.missing(:racing_stats).find_each do |horse|
      migrate_racing_stats(horse:)
    end
  end

  private

  def migrate_racing_stats(horse:)
    legacy = Legacy::Horse.where.not(Acceleration: nil).find_by(ID: horse
                                                                   .legacy_id)
    return unless legacy

    stats = horse.racing_stats || horse.build_racing_stats
    stats.acceleration = legacy.Acceleration
    stats.average_speed = legacy.Ave
    stats.break_speed = legacy.Break
    stats.closing = legacy.Close
    stats.consistency = legacy.Consistency
    stats.courage = legacy.Courage
    equipment = find_equipment(legacy.Equipment)
    stats.blinkers = equipment ? equipment[:blinkers] : false
    stats.shadow_roll = equipment ? equipment[:shadow_roll] : false
    stats.wraps = equipment ? equipment[:wraps] : false
    stats.figure_8 = equipment ? equipment[:figure_8] : false
    stats.no_whip = equipment ? equipment[:no_whip] : false
    stats.dirt = legacy.Dirt
    stats.energy = legacy.EnergyCurrent.presence || 100
    stats.energy_minimum = legacy.EnergyMin.presence || 0
    stats.energy_regain = legacy.EnergyRegain.presence || 0
    stats.fitness = legacy.Fitness.presence || 100
    stats.leading = legacy.Lead
    stats.loaf_percent = legacy.LoafPct
    stats.loaf_threshold = legacy.LoafThresh
    stats.max_speed = legacy.Max
    stats.midpack = legacy.Midpack
    stats.min_speed = legacy.Min
    stats.natural_energy_current = legacy.NaturalEnergy
    stats.natural_energy_gain = legacy.NEGain
    stats.natural_energy_loss = legacy.NELoss
    stats.off_pace = legacy.Pace
    stats.peak_start_date = legacy.ImmDate
    stats.peak_end_date = legacy.HBDate
    stats.pissy = legacy.Pissy
    stats.ratability = legacy.Ratability
    stats.soundness = legacy.Soundness
    stats.stamina = legacy.Stamina
    stats.steeplechase = legacy.SC
    stats.strides_per_second = legacy.SPS
    stats.sustain = legacy.Sustain
    stats.track_fast = legacy.Fast
    stats.track_good = legacy.Good
    stats.track_slow = legacy.Slow
    stats.track_wet = legacy.Wet
    stats.traffic = legacy.Traffic
    stats.turf = legacy.Turf
    stats.turning = legacy.Turning
    stats.weight = legacy.Weight
    stats.xp_current = legacy.XPCurrent.presence || 0
    stats.xp_rate = legacy.XPRate
    stats.save!
  end

  def find_equipment(equipment)
    return if equipment.blank?
    return if equipment.zero?

    legacy_equip = Legacy::Equipment.find(equipment)
    equip_list = legacy_equip.Equipment.split(" ")
    {
      blinkers: equip_list.include?("B"),
      shadow_roll: equip_list.include?("SR"),
      wraps: equip_list.include?("W"),
      figure_8: equip_list.include?("F8"),
      no_whip: equip_list.include?("NW")
    }
  end
end

