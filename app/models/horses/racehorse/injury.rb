module Horses::Racehorse
  class Injury < ApplicationRecord
    self.table_name = "injuries"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse"

    validates :date, :injury_type, :rest_date, presence: true
    validates :injury_type, inclusion: { in: Config::Injuries.types }
    validates :rest_date, comparison: { greater_than_or_equal_to: :date }

    scope :current, -> { where(date: ...Date.current).where("rest_date > ?", Date.current) }
    scope :healed, -> { where(rest_date: ...Date.current) }

    def self.ransackable_attributes(_auth_object = nil)
      %w[date horse_id injury_type rest_date]
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

