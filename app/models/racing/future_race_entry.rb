module Racing
  class FutureRaceEntry < ApplicationRecord
    include Equipmentable
    include RaceRunnable

    attr_accessor :entry_ship_date

    # enum :entry_status, { entered: "entered", errored: "errored", skipped: "skipped" }

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :race, class_name: "Racing::RaceSchedule"
    belongs_to :stable, class_name: "Account::Stable"
    belongs_to :first_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :second_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :third_jockey, class_name: "Racing::Jockey", optional: true

    validates :date, presence: true
    validates :entry_error, presence: true, if: :errored?
    validates :auto_enter, :auto_ship, :ship_when_entries_open,
      :ship_when_horse_is_entered, :ship_only_if_horse_is_entered,
      inclusion: { in: [true, false] }
    validates :horse_id, uniqueness: { scope: :date }

    scope :future, -> { where("date > ?", Date.current) }
    scope :past, -> { where(date: ...Date.current) }
    scope :processed, -> { where.not(entry_status: nil) }
    scope :not_processed, -> { where(entry_status: nil) }
    scope :succeeded, -> { where(entry_status: "entered") }
    scope :errored, -> { where(entry_status: "errored") }
    scope :skipped, -> { where(entry_status: "skipped") }
    scope :ordered_by_status, -> { order("entry_status ASC NULLS LAST") }

    def ship_mode = super.to_s.inquiry

    def store_initial_options
      self.date = race&.date
      self.ship_only_if_horse_is_entered = true
      self.auto_enter = true
      return unless horse

      options = horse.race_options
      self.first_jockey = options&.first_jockey
      self.second_jockey = options&.second_jockey
      self.third_jockey = options&.third_jockey
      self.equipment = options&.equipment
      self.racing_style = options&.racing_style
      self.entry_ship_date = "horse_entered"
    end

    def options_for_date_select
      list = Config::Shipping.future_entry_shipments.map do |method|
        [I18n.t("racing.shipping.future_races.#{method}"), method]
      end
      (Date.current..date - Config::Racing.entry_deadline_days.days).each do |date|
        list << [date, I18n.l(date)]
      end
      list
    end

    def options_for_mode_select
      Config::Shipping.modes.map do |mode|
        [I18n.t("racing.shipping.mode.#{mode}"), mode]
      end
    end
  end
end

# == Schema Information
#
# Table name: future_race_entries
# Database name: primary
#
#  id                                                                                                                                           :bigint           not null, primary key
#  auto_enter                                                                                                                                   :boolean          default(FALSE), not null, indexed
#  auto_ship                                                                                                                                    :boolean          default(FALSE), not null, indexed
#  date                                                                                                                                         :date             not null, indexed, uniquely indexed => [horse_id]
#  entry_error(race_full,not_at_track,already_entered,not_qualified,max_entries,cannot_afford_shipping,cannot_ship_in_time,cannot_afford_entry) :enum             indexed
#  entry_status(entered,errored,skipped)                                                                                                        :enum             indexed
#  equipment                                                                                                                                    :integer          default(0), not null, indexed
#  racing_style(leading,off_pace,midpack,closing)                                                                                               :enum             indexed
#  ship_date                                                                                                                                    :date             indexed
#  ship_mode(road, air)                                                                                                                         :enum             indexed
#  ship_only_if_horse_is_entered                                                                                                                :boolean          default(FALSE), not null, indexed
#  ship_when_entries_open                                                                                                                       :boolean          default(FALSE), not null, indexed
#  ship_when_horse_is_entered                                                                                                                   :boolean          default(FALSE), not null, indexed
#  created_at                                                                                                                                   :datetime         not null
#  updated_at                                                                                                                                   :datetime         not null
#  first_jockey_id                                                                                                                              :bigint           indexed
#  horse_id                                                                                                                                     :bigint           not null, uniquely indexed => [date]
#  race_id                                                                                                                                      :bigint           not null, indexed
#  second_jockey_id                                                                                                                             :bigint           indexed
#  stable_id                                                                                                                                    :bigint           not null, indexed
#  third_jockey_id                                                                                                                              :bigint           indexed
#
# Indexes
#
#  index_future_race_entries_on_auto_enter                     (auto_enter)
#  index_future_race_entries_on_auto_ship                      (auto_ship)
#  index_future_race_entries_on_date                           (date)
#  index_future_race_entries_on_entry_error                    (entry_error)
#  index_future_race_entries_on_entry_status                   (entry_status)
#  index_future_race_entries_on_equipment                      (equipment)
#  index_future_race_entries_on_first_jockey_id                (first_jockey_id)
#  index_future_race_entries_on_horse_id_and_date              (horse_id,date) UNIQUE
#  index_future_race_entries_on_race_id                        (race_id)
#  index_future_race_entries_on_racing_style                   (racing_style)
#  index_future_race_entries_on_second_jockey_id               (second_jockey_id)
#  index_future_race_entries_on_ship_date                      (ship_date)
#  index_future_race_entries_on_ship_mode                      (ship_mode)
#  index_future_race_entries_on_ship_only_if_horse_is_entered  (ship_only_if_horse_is_entered)
#  index_future_race_entries_on_ship_when_entries_open         (ship_when_entries_open)
#  index_future_race_entries_on_ship_when_horse_is_entered     (ship_when_horse_is_entered)
#  index_future_race_entries_on_stable_id                      (stable_id)
#  index_future_race_entries_on_third_jockey_id                (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (race_id => race_schedules.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (stable_id => stables.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

