class MigrateLegacyHorseBasicInfo < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    # return unless Rails.env.production?

    say_with_time "Migrating legacy horses" do
      say "Legacy horse count: #{LegacyHorse.count}"
      max_id = Horse.maximum("legacy_id") || 0
      say "Starting with id: #{max_id + 1}"
      LegacyHorse.where("id > ?", max_id).find_each do |legacy_horse|
        MigrateLegacyHorseService.new(horse: legacy_horse, locations: racetrack_locations).call
      end

      last_legacy_horse = LegacyHorse.order(id: :desc).first
      sleep(0.1) until Horse.exists?(legacy_id: last_legacy_horse.id)
      say "Horse count: #{Horse.count}"
      say "Sire count: #{Horse.where.not(sire: nil).count}"
      say "Dam count: #{Horse.where.not(dam: nil).count}"
    end
  end

  def down
    return unless Rails.env.production?

    say_with_time "Deleting existing horses" do
      ActiveRecord::Base.connection.execute("UPDATE horses SET sire_id = NULL, dam_id = NULL;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE horses CASCADE;")
    end
  end

  private

    def racetrack_locations
      return @racetrack_locations if @racetrack_locations

      ids = [1, 4, 7, 10, 13, 16, 19, 22, 28, 31, 34, 37, 40, 43, 48, 51, 55, 57]
      results = {}
      ids.each do |legacy_track_id|
        lrt = LegacyRacetrack.find(legacy_track_id)
        name = (lrt.send(:Name) == "Lone Star") ? "Lone Star Park" : lrt.send(:Name)
        location_id = Racetrack.where(name:).pick(:location_id)
        results[legacy_track_id] = location_id
      end
      @racetrack_locations = results
    end
end

