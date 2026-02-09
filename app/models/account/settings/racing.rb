module Account
  module Settings
    class Racing
      include StoreModel::Model

      attribute :min_energy_for_race_entry, :string
      attribute :min_days_delay_from_last_race, :integer
      attribute :min_days_delay_from_last_injury, :integer
      attribute :min_days_rest_between_races, :integer
      attribute :min_workouts_between_races, :integer
      attribute :apply_minimums_for_future_races, :boolean

      validates :min_energy_for_race_entry, inclusion: { in: Config::Racing.letter_grades.map(&:upcase) }, allow_nil: true
      validates :min_days_delay_from_last_race, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 365 }
      validates :min_days_delay_from_last_injury, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 365 }
      validates :min_days_rest_between_races, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 365 }
      validates :min_workouts_between_races, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 365 }
      validates :apply_minimums_for_future_races, inclusion: { in: [true, false] }
    end
  end
end

