class User < ApplicationRecord
  include Admin::UserAdmin

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_one :stable, dependent: :destroy

  accepts_nested_attributes_for :stable, allow_destroy: true

  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  enum status: { pending: "pending", active: "active", deleted: "deleted", banned: "banned" }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true, inclusion: { in: statuses }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :admin, inclusion: { in: [true, false] }
  validates :discourse_id, presence: true, uniqueness: true, on: :activate

  before_validation :set_defaults, on: :create

  broadcasts_to ->(_user) { "users" }, inserts_by: :prepend

  scope :ordered, -> { order(id: :desc) }

  attr_accessor :login

  # allow login via username or e-mail
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ["LOWER(username) = :value OR LOWER(email) = :value", { value: login.strip.downcase }]
    ).first
  end

  private

  def slug_candidates
    [
      :name,
      %i[name discourse_id]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed? || discourse_id_changed? || super
  end

  def set_defaults
    self.status ||= "pending"
    self.admin ||= false
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                         :bigint           not null, primary key
#  admin                                      :boolean          default(FALSE), not null
#  confirmation_sent_at                       :datetime
#  confirmation_token                         :string           indexed
#  confirmed_at                               :datetime
#  current_sign_in_at                         :datetime
#  current_sign_in_ip                         :string
#  email                                      :string           default(""), not null, indexed
#  encrypted_password                         :string           default(""), not null
#  failed_attempts                            :integer          default(0), not null
#  last_sign_in_at                            :datetime
#  last_sign_in_ip                            :string
#  locked_at                                  :datetime
#  name(displayed on profile)                 :string           not null
#  remember_created_at                        :datetime
#  reset_password_sent_at                     :datetime
#  reset_password_token                       :string           indexed
#  sign_in_count                              :integer          default(0), not null
#  slug                                       :string           indexed
#  status(pending, active, deleted, banned)   :enum             default("pending"), not null
#  unconfirmed_email                          :string
#  unlock_token                               :string           indexed
#  username                                   :string           not null, indexed
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  discourse_id(integer from Discourse forum) :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discourse_id          (discourse_id) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
