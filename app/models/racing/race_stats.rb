module Racing
  class RaceStats < ApplicationRecord
    self.table_name = "racehorse_stats"

    include FlagShihTzu

    GRADES = %w[A B C D F].freeze

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :racetrack, class_name: "Racing::Racetrack"

    validates :energy, :fitness, :natural_energy, :energy_regain_rate, :natural_energy_loss_rate,
      :natural_energy_regain_rate, :desired_equipment, :mature_at, :hasbeen_at,
      :rest_days_since_last_race, :workouts_since_last_race, presence: true
    validates :energy_grade, :fitness_grade, inclusion: { in: GRADES }
    validates :at_home, :in_transit, inclusion: { in: [true, false] }

    has_flags 1 => :blinkers,
      2 => :shadow_roll,
      3 => :wraps,
      4 => :figure_8,
      5 => :no_whip,
      :column => "desired_equipment"
  end
end

# == Schema Information
#
# Table name: racehorse_stats
# Database name: primary
#
#  id                         :bigint           not null, primary key
#  at_home                    :boolean          default(TRUE), not null, indexed
#  desired_equipment          :integer          default(0), not null, indexed
#  energy                     :integer          default(0), not null, indexed
#  energy_grade               :string           default("F"), not null, indexed
#  energy_regain_rate         :integer          default(0), not null, indexed
#  fitness                    :integer          default(0), not null, indexed
#  fitness_grade              :string           default("F"), not null, indexed
#  hasbeen_at                 :date             not null
#  in_transit                 :boolean          default(FALSE), not null, indexed
#  last_raced_at              :date             indexed
#  last_rested_at             :date             indexed
#  last_shipped_at            :date             indexed
#  mature_at                  :date             not null
#  natural_energy             :decimal(4, 1)    default(0.0), not null, indexed
#  natural_energy_loss_rate   :integer          default(0), not null, indexed
#  natural_energy_regain_rate :decimal(3, 2)    default(0.0), not null, indexed
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  horse_id                   :bigint           not null, uniquely indexed
#  racetrack_id               :bigint           not null, indexed
#
# Indexes
#
#  index_racehorse_stats_on_at_home                     (at_home)
#  index_racehorse_stats_on_desired_equipment           (desired_equipment)
#  index_racehorse_stats_on_energy                      (energy)
#  index_racehorse_stats_on_energy_grade                (energy_grade)
#  index_racehorse_stats_on_energy_regain_rate          (energy_regain_rate)
#  index_racehorse_stats_on_fitness                     (fitness)
#  index_racehorse_stats_on_fitness_grade               (fitness_grade)
#  index_racehorse_stats_on_horse_id                    (horse_id) UNIQUE
#  index_racehorse_stats_on_in_transit                  (in_transit)
#  index_racehorse_stats_on_last_raced_at               (last_raced_at)
#  index_racehorse_stats_on_last_rested_at              (last_rested_at)
#  index_racehorse_stats_on_last_shipped_at             (last_shipped_at)
#  index_racehorse_stats_on_natural_energy              (natural_energy)
#  index_racehorse_stats_on_natural_energy_loss_rate    (natural_energy_loss_rate)
#  index_racehorse_stats_on_natural_energy_regain_rate  (natural_energy_regain_rate)
#  index_racehorse_stats_on_racetrack_id                (racetrack_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (racetrack_id => racetracks.id)
#

