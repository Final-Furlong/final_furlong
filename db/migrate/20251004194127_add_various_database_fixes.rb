class AddVariousDatabaseFixes < ActiveRecord::Migration[8.0]
  def change
    ActiveRecord::Base.connection.execute "CREATE UNIQUE INDEX index_stables_on_name ON stables USING btree (lower(name));"

    add_index :auction_horses, %i[auction_id horse_id], unique: true
    add_index :track_surfaces, %i[racetrack_id surface], unique: true
    add_index :locations, %i[country name], unique: true

    add_check_constraint(:horse_appearances, "current_height >= birth_height", name: "current_height_must_be_valid")
    add_check_constraint(:horse_appearances, "max_height >= current_height", name: "max_height_must_be_valid")

    remove_index :track_surfaces, :racetrack_id if index_exists? :track_surfaces, :racetrack_id
    remove_index :auction_horses, :auction_id if index_exists? :auction_horses, :auction_id
  end
end

