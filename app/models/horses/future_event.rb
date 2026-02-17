module Horses
  class FutureEvent < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :future_events

    validates :date, :event_type, presence: true
    validates :date, comparison: { greater_than_or_equal_to: Date.current }

    enum :event_type, Config::Horses.future_events.reduce({}) { |hash, value| hash.merge({ value.to_sym => value }) }
  end
end

# == Schema Information
#
# Table name: future_events
# Database name: primary
#
#  id                                :bigint           not null, primary key
#  date                              :date             not null, indexed
#  event_type(retire, die, nominate) :enum             not null, indexed, uniquely indexed => [horse_id]
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  horse_id                          :bigint           not null, uniquely indexed => [event_type]
#
# Indexes
#
#  index_future_events_on_date                     (date)
#  index_future_events_on_event_type               (event_type)
#  index_future_events_on_horse_id_and_event_type  (horse_id,event_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

