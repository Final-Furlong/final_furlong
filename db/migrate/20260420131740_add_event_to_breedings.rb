class AddEventToBreedings < ActiveRecord::Migration[8.1]
  def change
    birth_events = %w[twins_alive twins_death stillborn death birth]
    create_enum :birth_events, birth_events

    safety_assured do
      change_table :breedings do |t|
        t.enum :event, enum_type: :birth_events, index: true, comment: birth_events.join(", ")
      end
    end
  end
end

