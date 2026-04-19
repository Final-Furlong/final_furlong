class AddOpenBreedingFlag < ActiveRecord::Migration[8.1]
  def change
    remove_index :breedings, %i[mare_id stud_id year], where: "status != 'denied'", unique: true, if_exists: true
    add_column :breedings, :open_booking, :boolean, default: false, null: false
    add_index :breedings, :open_booking
    add_index :breedings, %i[mare_id stud_id year], where: "open_booking IS FALSE AND status != 'denied'", unique: true, if_not_exists: true
  end
end

