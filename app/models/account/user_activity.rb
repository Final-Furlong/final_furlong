module Account
  class UserActivity < ApplicationRecord
    belongs_to :user
  end
end

# == Schema Information
#
# Table name: user_activities
# Database name: primary
#
#  id         :bigint           not null, primary key
#  activities :jsonb            indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_user_activities_on_activities  (activities) USING gin
#  index_user_activities_on_user_id     (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

