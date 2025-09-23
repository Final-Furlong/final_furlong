module Legacy
  class AuctionHorse < Record
    self.table_name = "ff_auctionhorses"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_auctionhorses
#
#  Auction :integer          default(0), not null, uniquely indexed => [Horse]
#  Comment :string(255)
#  Horse   :integer          default(0), not null, uniquely indexed => [Auction], indexed
#  ID      :integer          not null, primary key
#  Max     :integer
#  Reserve :integer
#  Sold    :boolean          default(FALSE), not null, indexed
#
# Indexes
#
#  Auction  (Auction,Horse) UNIQUE
#  Horse    (Horse)
#  Sold     (Sold)
#

