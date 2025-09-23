class CreateAuctionHorses < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    create_table :auction_horses, id: :uuid do |t|
      t.references :auction, type: :uuid
      t.references :horse, type: :uuid
      t.integer :reserve_price
      t.integer :max_price
      t.text :comment
      t.datetime :sold_at, index: { algorithm: :concurrently }

      t.timestamps
    end
  end
end

