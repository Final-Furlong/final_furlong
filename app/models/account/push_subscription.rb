class Account::PushSubscription < ApplicationRecord
  self.table_name = "user_push_subscriptions"

  belongs_to :user, inverse_of: :push_subscriptions

  def to_hash
    {
      endpoint:,
      keys: {
        p256dh: p256dh_key,
        auth: auth_key
      }
    }.deep_stringify_keys
  end
end

# == Schema Information
#
# Table name: user_push_subscriptions
# Database name: primary
#
#  id         :bigint           not null, primary key
#  auth_key   :string
#  endpoint   :string
#  p256dh_key :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_user_push_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade ON UPDATE => cascade
#

