class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user, class_name: "Account::User", inverse_of: :notifications

  scope :read, -> { where.not(read_at: nil) }
  scope :unread, -> { where(read_at: nil) }
  scope :param_equals, ->(key, val = true) {
    where("params ->> ? = ?", key.to_s, val.to_s)
  }

  broadcasts_refreshes

  def to_partial_path
    "notifications/notification"
  end

  def read?
    read_at.present?
  end

  def title
    I18n.t("notifications.notification.title")
  end

  def message
    I18n.t("notifications.notification.default_message")
  end

  def type
    :info
  end

  def icon
    true
  end

  def actions
    []
  end
end

# == Schema Information
#
# Table name: notifications
# Database name: primary
#
#  id         :bigint           not null, primary key
#  params     :jsonb
#  read_at    :datetime
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

