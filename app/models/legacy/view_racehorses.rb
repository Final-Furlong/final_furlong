module Legacy
  class ViewRacehorses < Record
    self.table_name = "horse_racehorses_mv"
    self.primary_key = "horse_id"
  end
end

# == Schema Information
#
# Table name: horse_racehorses_mv
# Database name: legacy
#
#  age                    :integer
#  allowance_wins_count   :integer          default(0), not null
#  boarded                :integer          default(0), not null
#  can_be_sold            :boolean          default(FALSE), not null
#  default_equipment      :string(20)
#  default_jockey         :integer
#  energy_grade           :string(1)
#  entered_to_race        :boolean          default(FALSE), not null
#  fitness_grade          :string(1)
#  flat_steeplechase      :string           default("F"), not null
#  gender                 :string
#  horse_name             :string(18)
#  in_transit             :boolean          default(FALSE), not null
#  injury_flag_expiration :date
#  last_race_finishers    :integer
#  leased                 :boolean          default(FALSE), not null
#  leaser                 :integer          default(0)
#  location               :integer          default(0)
#  owner                  :integer          default(0)
#  races_count            :integer          default(0), not null
#  rest_days_count        :integer          default(0), not null
#  riding_instructions    :integer
#  second_jockey          :integer
#  third_jockey           :integer
#  track_name             :string(255)
#  wins_count             :integer          default(0), not null
#  horse_id               :integer          not null, primary key, uniquely indexed
#  last_race_id           :integer
#  rails_boarding_id      :bigint
#
# Indexes
#
#  horse_id  (horse_id) UNIQUE
#

