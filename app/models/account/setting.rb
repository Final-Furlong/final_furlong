module Account
  class Setting < ApplicationRecord
    belongs_to :user
  end
end

# == Schema Information
#
# Table name: settings
#
#  id         :uuid             not null, primary key
#  locale     :string
#  theme      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             indexed
#
# Indexes
#
#  index_settings_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

