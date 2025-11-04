module Legacy
  class ViewTrainingSchedules < Record
    self.table_name = "horse_training_schedules_mv"
    self.primary_key = "horse_id"
  end
end

# == Schema Information
#
# Table name: horse_training_schedules_mv
# Database name: legacy
#
#  age                        :integer
#  default_equipment          :string(20)
#  default_jockey             :integer
#  default_workout_track      :integer
#  energy_current             :integer
#  energy_grade               :string(1)
#  fitness                    :integer
#  fitness_grade              :string(1)
#  flat_steeplechase          :string           default("F"), not null
#  gender                     :string
#  horse_name                 :string(18)
#  latest_injury_date         :date
#  leased                     :boolean          default(FALSE), not null, indexed => [leaser], indexed => [owner]
#  leaser                     :integer          default(0), indexed => [leased]
#  owner                      :integer          default(0), indexed => [leased]
#  track_name                 :string(255)
#  horse_id                   :integer          not null, primary key, uniquely indexed
#  race_entry_id              :integer
#  training_schedule_horse_id :integer
#  training_schedule_id       :integer
#
# Indexes
#
#  horse_id       (horse_id) UNIQUE
#  leaser_leased  (leaser,leased)
#  owner_leased   (owner,leased)
#

