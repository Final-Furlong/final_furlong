module Racing
  class WeatherForecast < ApplicationRecord
    belongs_to :surface, class_name: "TrackSurface", inverse_of: :weather_forecasts

    validates :date, :rain_chance, presence: true
    validates :date, comparison: { greater_than_or_equal_to: Date.current }
    validates :rain_chance, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

    scope :by_date, ->(date) { where(date:) }
  end
end

# == Schema Information
#
# Table name: weather_forecasts
# Database name: primary
#
#  id                               :bigint           not null, primary key
#  condition(fast, good, slow, wet) :enum
#  date                             :date             not null, indexed, uniquely indexed => [surface_id]
#  rain_chance                      :integer          default(0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  surface_id                       :bigint           not null, uniquely indexed => [date]
#
# Indexes
#
#  index_weather_forecasts_on_date                 (date)
#  index_weather_forecasts_on_surface_id_and_date  (surface_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (surface_id => track_surfaces.id)
#

