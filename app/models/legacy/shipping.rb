module Legacy
  class Shipping < Record
    self.table_name = "ff_shipping"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_shipping
# Database name: legacy
#
#  ACost      :integer
#  ADay       :integer
#  AEn        :integer
#  AFit       :integer
#  End        :integer          default(0), not null, uniquely indexed => [Start]
#  ID         :integer          not null, primary key
#  Miles      :integer          default(0), not null
#  RCost      :integer
#  RDay       :integer
#  REn        :integer
#  RFit       :integer
#  Start      :integer          default(0), not null, uniquely indexed => [End]
#  updated_at :datetime         not null
#
# Indexes
#
#  Start  (Start,End) UNIQUE
#

