class UpdateRacehorseStatsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Horses::Horse.racehorse.where.missing(:race_metadata).find_each do |horse|
      migrate_stats(horse:)
    end
  end

  private

  def migrate_stats(horse:)
    data = horse.race_metadata || horse.build_race_metadata
    stable = horse.manager
    legacy_horse = Legacy::Horse.find(horse.legacy_id)
    last_raced_at = Racing::RaceResult.joins(:horses).where(race_result_horses: { horse_id: horse.id })
      .maximum(:date)
    last_boarded_at = if Horses::Boarding.current.exists?(horse_id: horse.id)
      Date.current
    else
      Horses::Boarding.ended.where(horse_id: horse.id).maximum(:end_date)
    end
    last_shipped_at = Shipping::RacehorseShipment.where(horse_id: horse.id).maximum(:arrival_date)
    last_shipped_home_at = Shipping::RacehorseShipment.where(horse_id: horse.id, shipping_type: "track_to_farm").maximum(:arrival_date)
    last_rested_at = [last_boarded_at, last_shipped_home_at].compact.max
    racetrack = if legacy_horse.Location == 59
      stable.racetrack
    else
      legacy_racetrack = Legacy::Racetrack.find_by(ID: legacy_horse.Location)
      return stable.racetrack unless legacy_racetrack

      Racing::Racetrack.find_by(name: legacy_racetrack.Name)
    end
    equipment = if legacy_horse.Equipment.present? && legacy_horse.Equipment != 0
      legacy_equip = Legacy::Equipment.find(legacy_horse.Equipment)
      equip_list = legacy_equip.Equipment.split(" ")
      {
        blinkers: equip_list.include?("B"),
        shadow_roll: equip_list.include?("SR"),
        wraps: equip_list.include?("W"),
        figure_8: equip_list.include?("F8"),
        no_whip: equip_list.include?("NW")
      }
    end
    attrs = {
      energy: legacy_horse.EnergyCurrent,
      last_raced_at:,
      last_rested_at:,
      last_shipped_at:,
      fitness: legacy_horse.Fitness,
      natural_energy: legacy_horse.NaturalEnergy,
      energy_grade: legacy_horse.DisplayEnergy,
      fitness_grade: legacy_horse.DisplayFitness,
      energy_regain_rate: legacy_horse.EnergyRegain.to_f,
      natural_energy_loss_rate: legacy_horse.NELoss,
      natural_energy_regain_rate: legacy_horse.NEGain.to_f,
      racetrack:,
      at_home: legacy_horse.Location == 59,
      in_transit: false, # TODO: fix this
      blinkers: equipment ? equipment[:blinkers] : false,
      shadow_roll: equipment ? equipment[:shadow_roll] : false,
      wraps: equipment ? equipment[:wraps] : false,
      figure_8: equipment ? equipment[:figure_8] : false,
      no_whip: equipment ? equipment[:no_whip] : false,
      mature_at: legacy_horse.ImmDate,
      hasbeen_at: legacy_horse.HBDate
    }
    data.update(attrs)
  end
end

