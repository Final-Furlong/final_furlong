class AddAuctionConsignmentConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :auction_consignment_configs, id: :uuid do |t|
      t.references :auction, type: :uuid, null: false, foreign_key: { to_table: :auctions }
      t.string :horse_type, null: false
      t.integer :minimum_age, default: 0, null: false
      t.integer :maximum_age, default: 0, null: false
      t.integer :minimum_count, default: 0, null: false
      t.boolean :stakes_quality, default: false, null: false

      t.timestamps
    end

    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE UNIQUE INDEX index_consignment_configs_on_horse_type ON auction_consignment_configs (auction_id, lower(horse_type));
    SQL
  end
end

