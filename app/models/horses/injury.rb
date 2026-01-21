module Horses
  class Injury < ApplicationRecord
    self.table_name = "injuries"

    belongs_to :horse

    validates :date, :injury_type, :rest_date, presence: true
    validates :injury_type, inclusion: { in: Horses::HistoricalInjury::TYPES }
    validates :rest_date, comparison: { greater_than_or_equal_to: :date }

    scope :current, -> { where(date: ...Date.current).where("rest_date > ?", Date.current) }
    scope :healed, -> { where(rest_date: ...Date.current) }

    def self.rest_days(type)
      case type
      when "heat"
        rand(3...5)
      when "swelling"
        rand(5...7)
      when "cut"
        rand(7...14)
      when "limping"
        rand(14...21)
      when "overheat"
        rand(30...65)
      when "bowed tendon"
        rand(60...95)
      when "broken leg"
        rand(365...435)
      end
    end

    def self.pick_leg(type)
      case type
      when "heat", "swelling", "cut", "limping", "bowed tendon", "broken leg"
        HistoricalInjury::LEGS.sample
      end
    end
  end
end

# == Schema Information
#
# Table name: injuries
# Database name: primary
#
#  id          :bigint           not null, primary key
#  date        :date             not null, indexed
#  injury_type :enum             not null, indexed
#  rest_date   :date             not null, indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  horse_id    :bigint           not null, indexed
#
# Indexes
#
#  index_injuries_on_date         (date)
#  index_injuries_on_horse_id     (horse_id)
#  index_injuries_on_injury_type  (injury_type)
#  index_injuries_on_rest_date    (rest_date)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

