# frozen_string_literal: true

class UpdatePointsForRaceFinishes < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Racing::RaceResultHorse.by_finish(1).joins(:race).merge(Racing::RaceResult.by_type("stakes")).update_all(points: 42)
    Racing::RaceResultHorse.by_finish(2).joins(:race).merge(Racing::RaceResult.by_type("stakes")).update_all(points: 21)
    Racing::RaceResultHorse.by_finish(3).joins(:race).merge(Racing::RaceResult.by_type("stakes")).update_all(points: 10)
    Racing::RaceResultHorse.by_finish(4).joins(:race).merge(Racing::RaceResult.by_type("stakes")).update_all(points: 7)
    Racing::RaceResultHorse.where(finish_position: 5..).joins(:race).merge(Racing::RaceResult.by_type("stakes")).update_all(points: 0)
    allow_types = %w[starter_allowance nw1_allowance nw2_allowance nw3_allowance allowance]
    Racing::RaceResultHorse.by_finish(1).joins(:race).merge(Racing::RaceResult.by_type(allow_types)).update_all(points: 10)
    Racing::RaceResultHorse.by_finish(2).joins(:race).merge(Racing::RaceResult.by_type(allow_types)).update_all(points: 7)
    Racing::RaceResultHorse.by_finish(3).joins(:race).merge(Racing::RaceResult.by_type(allow_types)).update_all(points: 3)
    Racing::RaceResultHorse.where(finish_position: 4..).joins(:race).merge(Racing::RaceResult.by_type(allow_types)).update_all(points: 0)
    other_types = %w[maiden claiming]
    Racing::RaceResultHorse.by_finish(1).joins(:race).merge(Racing::RaceResult.by_type(other_types)).update_all(points: 2)
    Racing::RaceResultHorse.by_finish(2).joins(:race).merge(Racing::RaceResult.by_type(other_types)).update_all(points: 1)
    Racing::RaceResultHorse.where(finish_position: 3..).joins(:race).merge(Racing::RaceResult.by_type(other_types)).update_all(points: 0)
    # rubocop:enable Rails/SkipsModelValidations

    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    Racing::StableRaceRecord.refresh
    Racing::StableAnnualRaceRecord.refresh
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

