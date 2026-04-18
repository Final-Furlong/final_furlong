class Horses::Horse::Racing < ActiveRecord::AssociatedObject
  record.has_one :race_options, class_name: "Racing::RaceOption", dependent: :delete
  record.has_one :racing_stats, class_name: "Racing::RacingStats", dependent: :delete
  record.has_many :workout_stats, class_name: "Workouts::Stat", dependent: :delete_all

  record.scope :runs_on_dirt, -> { joins(:race_options).merge(::Racing::RaceOption.dirt) }
  record.scope :runs_on_turf, -> { joins(:race_options).merge(::Racing::RaceOption.turf) }
  record.scope :runs_on_steeplechase, -> { joins(:race_options).merge(::Racing::RaceOption.jump) }

  def at_farm?
    record.race_metadata.at_home?
  end

  def in_transit?
    record.race_metadata.in_transit?
  end

  def current_location_name
    record.race_metadata.location.name
  end

  def last_shipment
    record.racing_shipments.not_future.order(arrival_date: :desc).first
  end
end

