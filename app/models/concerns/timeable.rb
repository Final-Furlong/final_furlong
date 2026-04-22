module Timeable
  extend ActiveSupport::Concern

  included do
    validates :time_in_seconds, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000 }

    def time_string
      minutes = (time_in_seconds / 60).floor
      seconds = (time_in_seconds % 60).floor
      remainder = (time_in_seconds % 60).to_s.split(".").last
      seconds = [seconds, remainder].join(".")
      [minutes, seconds].join(":")
    end
  end
end

