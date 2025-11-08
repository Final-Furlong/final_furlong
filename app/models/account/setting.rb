module Account
  class Setting < ApplicationRecord
    self.ignored_columns += ["old_id"]

    belongs_to :user

    validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s), message: :invalid }

    def time_zone
      nil
    end
  end
end

# == Schema Information
#
# Table name: settings
# Database name: primary
#
#  id         :bigint           not null, primary key
#  locale     :string
#  theme      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_settings_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade ON UPDATE => cascade
#

