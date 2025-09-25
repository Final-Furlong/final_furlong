class MoreActiveRecordDoctorFixes < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      # rubocop:disable Rails/ReversibleMigration
      change_column :auctions, :title, :string, limit: 500
      # rubocop:enable Rails/ReversibleMigration
    end

    change_column_null :auctions, :auctioneer_id, false
    change_column_null :auction_bids, :auction_id, false
    change_column_null :auction_bids, :horse_id, false
    change_column_null :auction_bids, :bidder_id, false
    change_column_null :auction_horses, :auction_id, false
    change_column_null :auction_horses, :horse_id, false
    change_column_null :horse_appearances, :horse_id, false
    change_column_null :horse_appearances, :birth_height, false
    change_column_null :horse_appearances, :current_height, false
    change_column_null :horse_appearances, :max_height, false
    change_column_null :horse_genetics, :horse_id, false
    change_column_null :horse_genetics, :allele, false

    add_foreign_key :auction_horses, :auctions
    add_foreign_key :auction_horses, :horses
    add_foreign_key :auction_bids, :auctions
  end
end

