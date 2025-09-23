class CreateAuctionBids < ActiveRecord::Migration[8.0]
  def change
    create_table :auction_bids, id: :uuid do |t|
      t.references :auction, type: :uuid
      t.references :horse, type: :uuid, foreign_key: { to_table: :auction_horses }
      t.references :bidder, type: :uuid, foreign_key: { to_table: :stables }
      t.integer :current_bid, default: 0, null: false
      t.integer :maximum_bid
      t.text :comment
      t.boolean :email_if_outbid, default: false, null: false

      t.timestamps
    end
  end
end

