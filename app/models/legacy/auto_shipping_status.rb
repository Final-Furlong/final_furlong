module Legacy
  class AutoShippingStatus < Record
    self.table_name = "auto_shipping_status"
  end
end

# == Schema Information
#
# Table name: auto_shipping_status
#
#  id        :integer          not null, primary key
#  location  :integer          not null
#  ship_date :date             uniquely indexed => [horse_id]
#  status    :string(255)      indexed
#  horse_id  :integer          not null, uniquely indexed => [ship_date]
#  user_id   :integer          not null, indexed
#
# Indexes
#
#  horse_id  (horse_id,ship_date) UNIQUE
#  status    (status)
#  user_id   (user_id)
#

