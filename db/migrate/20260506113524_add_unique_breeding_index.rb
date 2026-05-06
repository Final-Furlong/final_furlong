class AddUniqueBreedingIndex < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :breedings, %i[stud_id year mare_id], if_exists: true
    add_index :breedings, %i[stud_id year mare_id], name: "idx_breedings_denied_stud_mare_year", where: "status = 'denied'", algorithm: :concurrently
    add_index :breedings, %i[stud_id year mare_id], where: "status != 'denied'", unique: true, algorithm: :concurrently
  end
end

