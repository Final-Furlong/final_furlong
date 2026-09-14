class UpdateUniqueIndexesOnAuctionConfigs < ActiveRecord::Migration[8.1]
  def change
    remove_index :auction_consignment_configs, name: "index_auction_configs_on_horse_type", if_exists: true
    ActiveRecord::Base.connection.execute(
      "CREATE UNIQUE INDEX index_auction_configs_on_horse_type ON public.auction_consignment_configs USING btree (auction_id, lower((horse_type)::text), stakes_quality);"
    )
  end
end

