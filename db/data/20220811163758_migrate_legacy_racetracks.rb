class MigrateLegacyRacetracks < ActiveRecord::Migration[7.0]
  def up
    # return unless Rails.env.production?

    say_with_time "Migrating legacy tracks" do
      MigrateLegacyRacetrackService.new.call
      say "Legacy racetrack count: #{Legacy::Racetrack.count}"
      say "Racetrack count: #{Racing::Racetrack.count}"
      say "Track surface count: #{Racing::TrackSurface.count}"
      say "Location count: #{Location.count}"
    end
  end

  def down
    # return unless Rails.env.production?

    say_with_time "Deleting existing tracks" do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE track_surfaces CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE racetracks CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE locations CASCADE;")
    end
  end
end

