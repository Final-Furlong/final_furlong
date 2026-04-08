class SetStableReferenceForEntries < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Racing::RaceEntry.where(stable_id: nil).find_each do |entry|
      horse = entry.horse
      entry.update_columns(stable_id: horse.leaser_id || horse.owner_id)
    end
    Racing::FutureRaceEntry.where(stable_id: nil).find_each do |entry|
      horse = entry.horse
      entry.update_columns(stable_id: horse.leaser_id || horse.owner_id)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    # rubocop:disable Rails/SkipsModelValidations
    Racing::RaceEntry.where.not(stable_id: nil).update_all(stable_id: nil)
    Racing::FutureRaceEntry.where.not(stable_id: nil).update_all(stable_id: nil)
    # rubocop:enable Rails/SkipsModelValidations
  end
end

