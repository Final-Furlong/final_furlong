class CreateLeaseOffers < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    create_table :lease_offers do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.references :owner, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.references :leaser, type: :bigint, index: true, foreign_key: { to_table: :stables }
      t.boolean :new_members_only, default: false, null: false
      t.date :offer_start_date, null: false, index: true
      t.integer :duration_months, null: false
      t.integer :fee, default: 0, null: false

      t.timestamps
    end
    remove_index :lease_offers, :horse_id, if_exists: true
    add_index :lease_offers, :horse_id, unique: true, algorithm: :concurrently
  end
end

