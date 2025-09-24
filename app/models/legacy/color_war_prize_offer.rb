module Legacy
  class ColorWarPrizeOffer < Record
    self.table_name = "ff_cw_prize_offers"
  end
end

# == Schema Information
#
# Table name: ff_cw_prize_offers
#
#  id       :integer          not null, primary key
#  year     :string(4)        not null
#  horse_id :integer          not null, indexed => [user_id]
#  user_id  :integer          not null, indexed => [horse_id]
#
# Indexes
#
#  user_horse  (user_id,horse_id)
#

