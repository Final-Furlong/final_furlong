class AddSlugToTables < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_column :auctions, :slug, :string
    add_column :auction_horses, :slug, :string

    add_index :auctions, :slug, unique: true, algorithm: :concurrently
    add_index :auction_horses, :slug, unique: true, algorithm: :concurrently
    add_index :jockeys, %i[first_name last_name], unique: true, algorithm: :concurrently
  end
end

