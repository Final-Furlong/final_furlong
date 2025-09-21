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
#  theme      :string
#  locale     :string
#  user_id    :uuid             not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_settings_on_user_id  (user_id) UNIQUE
#

