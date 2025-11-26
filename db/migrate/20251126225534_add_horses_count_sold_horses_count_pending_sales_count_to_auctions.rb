class AddHorsesCountSoldHorsesCountPendingSalesCountToAuctions < ActiveRecord::Migration[8.1]
  def self.up
    add_column :auctions, :horses_count, :integer, null: false, default: 0

    add_column :auctions, :sold_horses_count, :integer, null: false, default: 0

    add_column :auctions, :pending_sales_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :auctions, :horses_count

    remove_column :auctions, :sold_horses_count

    remove_column :auctions, :pending_sales_count
  end
end

