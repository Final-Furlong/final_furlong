module Game
  class Alert < ApplicationRecord
    self.table_name = "game_alerts"
    self.ignored_columns += ["old_id"]

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
#  id                     :bigint           not null, primary key
#  display_to_newbies     :boolean          default(TRUE), not null, indexed
#  display_to_non_newbies :boolean          default(TRUE), not null, indexed
#  end_time               :datetime         indexed
#  message                :text             not null
#  start_time             :datetime         not null, indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_game_alerts_on_display_to_newbies      (display_to_newbies)
#  index_game_alerts_on_display_to_non_newbies  (display_to_non_newbies)
#  index_game_alerts_on_end_time                (end_time)
#  index_game_alerts_on_old_id                  (old_id)
#  index_game_alerts_on_start_time              (start_time)
#

