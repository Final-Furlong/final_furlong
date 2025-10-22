module Racing
  class Odd < ApplicationRecord
    self.table_name = "race_odds"

    has_many :race_result_horses, class_name: "Racing::RaceResultHorse", inverse_of: :odd, dependent: :nullify

    validates :display, :value, presence: true
  end
end

# == Schema Information
#
# Table name: race_odds
#
#  id         :uuid             not null, primary key
#  display    :string           not null
#  value      :decimal(3, 1)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

