module Game
  class Alert < ApplicationRecord
    self.table_name = "game_alerts"

    validates :message, :start_time, presence: true
    validates :end_time, comparison: { greater_than: :start_time }, allow_nil: true, if: :start_time
    validates :message, length: { minimum: 10 }
    validates :display_to_newbies, inclusion: { in: [true, false] }
    validates :display_to_non_newbies, inclusion: { in: [true, false] }
  end
end

# == Schema Information
#
# Table name: game_alerts
#
#  id                     :uuid             not null, primary key
#  display_to_newbies     :boolean          default(TRUE), not null
#  display_to_non_newbies :boolean          default(TRUE), not null
#  end_time               :timestamp        indexed
#  message                :text             not null
#  start_time             :timestamp        not null, indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_game_alerts_on_end_time    (end_time)
#  index_game_alerts_on_start_time  (start_time)
#

