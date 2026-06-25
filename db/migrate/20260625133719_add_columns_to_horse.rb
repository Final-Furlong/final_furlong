class AddColumnsToHorse < ActiveRecord::Migration[8.1]
  def change
    states = %w[active retired unborn deceased]
    create_enum :horse_states, states, if_not_exists: true

    add_column :horses, :type, :string, default: "Horses::Horse::Foal", comment: %w[Racehorse Broodmare Stud Foal].join(","), if_not_exists: true
    add_column :horses, :state, :enum, enum_type: :horse_states, default: "active", comment: states.join(","), if_not_exists: true

    add_index :horses, :type, if_not_exists: true
    add_index :horses, :state, if_not_exists: true
  end
end

