class AddOwnerIndexToHorses < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :horses, :owner_id, if_not_exists: true, algorithm: :concurrently
  end
end

