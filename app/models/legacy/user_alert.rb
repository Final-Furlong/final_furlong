module Legacy
  class UserAlert < Record; end
end

# == Schema Information
#
# Table name: user_alerts
# Database name: legacy
#
#  id             :integer          not null, primary key
#  activates_at   :date             not null, indexed => [user_id]
#  dismissed_at   :date
#  expires_at     :date             indexed => [user_id]
#  message        :text(4294967295) not null
#  read_at        :date
#  reference_type :string(255)
#  reference_id   :integer
#  user_id        :integer          indexed => [activates_at], indexed => [expires_at]
#
# Indexes
#
#  user_date    (user_id,activates_at)
#  user_expire  (user_id,expires_at)
#

