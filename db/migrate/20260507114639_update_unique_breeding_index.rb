class UpdateUniqueBreedingIndex < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :breedings, %i[stud_id year mare_id], name: :index_breedings_on_stud_id_and_year_and_mare_id, if_exists: true
    add_index :breedings, %i[stud_id year mare_id], where: "status != 'denied' AND mare_id IS NOT NULL", unique: true, algorithm: :concurrently
  end
end

