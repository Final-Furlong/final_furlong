class CreateAuctions < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    create_table :auctions, id: :uuid do |t|
      t.datetime :start_time, null: false, index: { algorithm: :concurrently }
      t.datetime :end_time, null: false, index: { algorithm: :concurrently }
      t.references :auctioneer, type: :uuid, foreign_key: { to_table: :stables }
      t.string :title, null: false
      t.integer :hours_until_sold, null: false, default: 12
      t.boolean :reserve_pricing_allowed, default: false, null: false
      t.boolean :outside_horses_allowed, default: false, null: false
      t.integer :spending_cap_per_stable
      t.integer :horse_purchase_cap_per_stable
      t.boolean :racehorse_allowed_2yo, default: false, null: false
      t.boolean :racehorse_allowed_3yo, default: false, null: false
      t.boolean :racehorse_allowed_older, default: false, null: false
      t.boolean :stallion_allowed, default: false, null: false
      t.boolean :broodmare_allowed, default: false, null: false
      t.boolean :yearling_allowed, default: false, null: false
      t.boolean :weanling_allowed, default: false, null: false

      t.timestamps
    end
  end
end

