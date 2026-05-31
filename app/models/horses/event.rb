module Horses
  class Event < ApplicationRecord
    self.table_name = "horse_events"

    EVENT_TYPES = %w[gelded switched_to_sc retired_racing retired_breeding]

    belongs_to :horse, class_name: "Horses::Horse"

    validates :date, presence: true
    validates :event_type, inclusion: { in: EVENT_TYPES }
    validates :event_type, uniqueness: { scope: :horse_id }
  end
end

# == Schema Information
#
# Table name: horse_events
# Database name: primary
#
#  id                                                                :bigint           not null, primary key
#  date                                                              :date             not null, indexed
#  event_type(gelded,switched_to_sc,retired_racing,retired_breeding) :enum             indexed, uniquely indexed => [horse_id]
#  created_at                                                        :datetime         not null
#  updated_at                                                        :datetime         not null
#  horse_id                                                          :bigint           not null, uniquely indexed => [event_type]
#
# Indexes
#
#  index_horse_events_on_date                     (date)
#  index_horse_events_on_event_type               (event_type)
#  index_horse_events_on_horse_id_and_event_type  (horse_id,event_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

