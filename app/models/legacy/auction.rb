module Legacy
  class Auction < Record
    self.table_name = "ff_auctions"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_auctions
#
#  AllowOutside :boolean          default(FALSE), not null
#  AllowRes     :boolean          default(TRUE), not null
#  AllowStatus  :string(255)      default("All"), not null
#  Auctioneer   :integer          default(0), not null
#  ConsignLimit :integer
#  End          :datetime         default(NULL), not null, indexed
#  ID           :integer          not null, primary key
#  PerPerson    :integer
#  SellTime     :string(255)      default("12"), not null
#  SpendingCap  :integer
#  Start        :datetime         default(NULL), not null, indexed
#  Title        :string(255)
#
# Indexes
#
#  End    (End)
#  Start  (Start)
#

