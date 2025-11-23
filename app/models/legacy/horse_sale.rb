module Legacy
  class HorseSale < Record
    self.table_name = "ff_horse_sales"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_sales
# Database name: legacy
#
#  Buyer  :integer          indexed
#  Date   :date             not null, indexed, indexed => [Seller]
#  Horse  :integer          indexed
#  ID     :integer          not null, primary key
#  PT     :boolean          default(TRUE), not null, indexed
#  Price  :integer
#  Seller :integer          indexed, indexed => [Date]
#
# Indexes
#
#  Buyer        (Buyer)
#  Date         (Date)
#  Horse        (Horse)
#  PT           (PT)
#  Seller       (Seller)
#  Seller Date  (Date,Seller)
#

