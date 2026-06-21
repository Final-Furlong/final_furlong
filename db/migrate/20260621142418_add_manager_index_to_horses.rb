class AddManagerIndexToHorses < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :horses, %i[date_of_birth manager_id], algorithm: :concurrently
    drop_index :horses, :date_of_birth, if_exists: true
  end
end

