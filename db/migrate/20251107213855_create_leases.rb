class CreateLeases < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    create_table :leases do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.references :owner, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.references :leaser, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.date :start_date, null: false, index: true
      t.date :end_date, null: false, index: true
      t.integer :fee, default: 0, null: false
      t.date :early_termination_date, index: true
      t.boolean :active, default: true, null: false, index: true

      t.timestamps
    end
    remove_index :leases, :horse_id, if_exists: true
    add_index :leases, :horse_id, where: "active = true", unique: true, algorithm: :concurrently

    create_table :lease_termination_requests do |t|
      t.references :lease, type: :bigint, null: false, foreign_key: { to_table: :leases }
      t.boolean :leaser_accepted_end, default: false, null: false
      t.boolean :owner_accepted_end, default: false, null: false
      t.boolean :leaser_accepted_refund, default: false, null: false
      t.boolean :owner_accepted_refund, default: false, null: false

      t.timestamps
    end
    remove_index :lease_termination_requests, :lease_id, if_exists: true
    add_index :lease_termination_requests, :lease_id, unique: true, algorithm: :concurrently
  end
end

