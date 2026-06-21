class AddManagerIndexToHorses < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :horses, %i[date_of_birth manager_id], if_not_exists: true, algorithm: :concurrently
    remove_index :horses, :date_of_birth, if_exists: true
  end
end

