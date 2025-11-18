class SetBidAtForExistingBids < ActiveRecord::Migration[8.1]
  def up
    Auctions::Bid.where("bid_at > updated_at").find_each do |bid|
      bid.update(bid_at: bid.updated_at)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

