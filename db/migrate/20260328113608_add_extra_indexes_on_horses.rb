class AddExtraIndexesOnHorses < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :horses, %i[status age], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status gender], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status name], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status owner_id], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status breeder_id], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status leaser_id], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status sire_id], algorithm: :concurrently, if_not_exists: true
    add_index :horses, %i[status dam_id], algorithm: :concurrently, if_not_exists: true
  end
end

