# frozen_string_literal: true

class User < ApplicationRecord
  enum status: { pending: "pending", active: "active", deleted: "deleted", banned: "banned" }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true, inclusion: { in: statuses }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :admin, inclusion: { in: [true, false] }
  validates :discourse_id, presence: true, uniqueness: true, on: :activate

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.status ||= "pending"
    self.admin ||= false
  end
end

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  admin        :boolean          default(FALSE), not null
#  email        :string           not null
#  name         :string           not null
#  status       :enum             default("pending"), not null
#  username     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  discourse_id :integer
#
# Indexes
#
#  index_users_on_discourse_id  (discourse_id) UNIQUE
#  index_users_on_email         (email) UNIQUE
#  index_users_on_username      (username) UNIQUE
#
