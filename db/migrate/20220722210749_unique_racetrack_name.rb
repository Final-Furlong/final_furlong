class UniqueRacetrackName < ActiveRecord::Migration[7.0]
  def change
    remove_index :racetracks, :name

    add_index :racetracks, :name, unique: true
  end
end

