module Racing
  class Racehorse < ApplicationModel
    attribute :id, Types::String

    attribute :acceleration, Types::Integer
    attribute :ave_speed, Types::Integer
    attribute :break, Types::Integer
    attribute :close, Types::Integer
    attribute :consistency, Types::Integer
    attribute :courage, Types::Integer
    attribute :default_equipment, Types::Integer
    attribute :dirt, Types::Integer
    attribute :energy, Types::Integer
    attribute :energy_grade, Types::String
    attribute :energy_minimum, Types::Integer
    attribute :energy_regain, Types::Integer
    attribute :equipment, Types::Integer
    attribute :fast, Types::Integer
    attribute :fitness, Types::Integer
    attribute :fitness_grade, Types::String
    attribute :good, Types::Integer
    attribute :hasbeen_date, Types::Date
    attribute :immature_date, Types::Date
    attribute :last_race_finishers, Types::Integer
    attribute :last_race_id, UUID
    attribute :lead, Types::Integer
    attribute :loaf_percent, Types::Integer
    attribute :loaf_threshold, Types::Integer
    attribute :max_speed, Types::Integer
    attribute :midpack, Types::Integer
    attribute :min_speed, Types::Integer
    attribute :morale, Types::Float
    attribute :morale_gain, Types::Integer
    attribute :morale_loss, Types::Integer
    attribute :pace, Types::Integer
    attribute :pissy, Types::Integer
    attribute :races_count, Types::Integer
    attribute :ratability, Types::Integer
    attribute :rest_day_count, Types::Integer
    attribute :slow, Types::Integer
    attribute :soundness, Types::Integer
    attribute :stamina, Types::Integer
    attribute :steeeplechase, Types::Integer
    attribute :strides_per_second, Types::Float
    attribute :sustain, Types::Integer
    attribute :traffic, Types::Integer
    attribute :turf, Types::Integer
    attribute :turning, Types::Integer
    attribute :weight, Types::Integer
    attribute :wet, Types::Integer
    attribute :xp_current, Types::Integer
    attribute :xp_rate, Types::Integer

    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime
  end
end

