module Racing
  class Odd < ApplicationRecord
    self.table_name = "race_odds"
    self.ignored_columns += ["old_id"]

    has_many :race_result_horses, class_name: "Racing::RaceResultHorse", inverse_of: :odd, dependent: :nullify

    validates :display, :value, presence: true
  end
end

# == Schema Information
#
# Table name: race_odds
# Database name: primary
#
#  id         :bigint           not null, primary key
#  display    :string           not null, indexed
#  value      :decimal(3, 1)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_race_odds_on_display  (display)
#  index_race_odds_on_old_id   (old_id)
#

