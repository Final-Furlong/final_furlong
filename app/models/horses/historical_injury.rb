module Horses
  class HistoricalInjury < ApplicationRecord
    self.table_name = "historical_injuries"

    belongs_to :horse

    validates :date, :injury_type, presence: true
    validates :injury_type, inclusion: { in: Config::Injuries.types }
    validates :leg, inclusion: { in: Config::Injuries.legs.map(&:upcase) }, allow_nil: true

    scope :current, -> { where(date: ...Date.current).where("rest_date > ?", Date.current) }
    scope :healed, -> { where(rest_date: ...Date.current) }
  end
end

# == Schema Information
#
# Table name: historical_injuries
# Database name: primary
#
#  id          :bigint           not null, primary key
#  date        :date             not null, indexed
#  injury_type :enum             not null, indexed
#  leg         :enum
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  horse_id    :bigint           not null, indexed
#
# Indexes
#
#  index_historical_injuries_on_date         (date)
#  index_historical_injuries_on_horse_id     (horse_id)
#  index_historical_injuries_on_injury_type  (injury_type)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

