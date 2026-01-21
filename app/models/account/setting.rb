module Account
  class Setting < ApplicationRecord
    include StoreModel::NestedAttributes

    belongs_to :user

    attribute :racing, Settings::Racing.to_type
    attribute :website, Settings::Website.to_type

    validates :time_zone, presence: true, inclusion: {
      in: ActiveSupport::TimeZone.all.map(&:tzinfo).map(&:identifier)
    }
    validates :racing, store_model: true
    validates :website, store_model: true

    accepts_nested_attributes_for :racing, :website, allow_destroy: true

    delegate :locale, to: :website
  end
end

# == Schema Information
#
# Table name: settings
# Database name: primary
#
#  id         :bigint           not null, primary key
#  dark_mode  :boolean          default(FALSE), not null
#  dark_theme :string
#  locale     :string
#  racing     :jsonb
#  theme      :string
#  time_zone  :string           default("America/New_York"), not null
#  website    :jsonb
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

