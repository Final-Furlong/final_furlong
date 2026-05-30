module Account
  class User < ApplicationRecord
    include Discard::Model
    include PublicIdGenerator
    include FriendlyId

    friendly_id :username, use: [:slugged, :finders]

    self.strict_loading_by_default = false
    self.ignored_columns += ["encrypted_password", "reset_password_sent_at", "reset_password_token", "unlock_token"]

    attr_accessor :login

    has_one :stable, dependent: :destroy
    has_one :activity, class_name: "Account::UserActivity", dependent: :delete
    has_one :activation, class_name: "Account::Activation", dependent: :delete
    has_one :setting, dependent: :delete

    has_many :notifications, inverse_of: :user, dependent: :destroy
    has_many :push_subscriptions, inverse_of: :user, dependent: :delete_all

    # Include default devise modules. Others available are:
    # :omniauthable, :database_authenticatable, :registerable, :recoverable, :lockable
    devise :rememberable, :confirmable, :timeoutable, :trackable # codespell:ignore rememberable

    enum :status, { pending: "pending", active: "active", deleted: "deleted", banned: "banned" }

    validates :username, :status, :name, :email, presence: true
    validates :admin, inclusion: { in: [true, false] }
    validates :developer, inclusion: { in: [true, false] }
    validates :username, uniqueness: { case_sensitive: false }, length: { minimum: Config::Game.username_minimum_length }
    validates :email, uniqueness: { case_sensitive: false }
    validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

    scope :developer, -> { where(developer: true) }

    delegate :locale, to: :setting, allow_nil: true

    # broadcasts_to ->(_user) { "users" }, inserts_by: :prepend

    # :nocov:
    def active_for_authentication?
      super && !discarded?
    end

    # :nocov:

    def self.ransackable_attributes(_auth_object = nil)
      %w[username status name email]
    end
  end
end

# == Schema Information
#
# Table name: users
# Database name: primary
#
#  id                                       :bigint           not null, primary key
#  admin                                    :boolean          default(FALSE), not null, indexed
#  confirmation_sent_at                     :datetime
#  confirmation_token                       :string
#  confirmed_at                             :datetime
#  current_sign_in_at                       :datetime
#  current_sign_in_ip                       :string
#  developer                                :boolean          default(FALSE), not null, indexed
#  discarded_at                             :datetime
#  email                                    :string           default(""), not null
#  failed_attempts                          :integer          default(0), not null
#  last_sign_in_at                          :datetime
#  last_sign_in_ip                          :string
#  locked_at                                :datetime
#  name                                     :string           not null, indexed
#  remember_created_at                      :datetime
#  sign_in_count                            :integer          default(0), not null
#  slug                                     :string           uniquely indexed
#  status(pending, active, deleted, banned) :enum             default("pending"), not null
#  unconfirmed_email                        :string
#  username                                 :string           not null, uniquely indexed
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  discourse_id                             :integer          uniquely indexed
#  public_id                                :string(12)       uniquely indexed
#
# Indexes
#
#  index_users_on_admin         (admin) WHERE (discarded_at IS NOT NULL)
#  index_users_on_developer     (developer) WHERE (discarded_at IS NOT NULL)
#  index_users_on_discourse_id  (discourse_id) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_email         (lower((email)::text)) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_name          (name) WHERE (discarded_at IS NOT NULL)
#  index_users_on_public_id     (public_id) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_slug          (slug) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_username      (username) UNIQUE WHERE (discarded_at IS NOT NULL)
#

