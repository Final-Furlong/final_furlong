module Account
  class User < ApplicationRecord
    include Discard::Model
    include PublicIdGenerator
    include FriendlyId

    friendly_id :username, use: [:slugged, :finders]

    attr_accessor :login

    USERNAME_LENGTH = 4
    PASSWORD_LENGTH = 8

    has_one :stable, dependent: :destroy
    has_one :activation, class_name: "Account::Activation", dependent: :delete
    has_one :setting, dependent: :delete
    has_many :push_subscriptions, inverse_of: :user, dependent: :delete_all

    # Include default devise modules. Others available are:
    # :omniauthable
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable,
      :confirmable, :lockable, :timeoutable, :trackable

    enum :status, { pending: "pending", active: "active", deleted: "deleted", banned: "banned" }

    validates :username, :status, :name, presence: true
    validates :admin, inclusion: { in: [true, false] }
    validates :developer, inclusion: { in: [true, false] }
    validates :username, uniqueness: { case_sensitive: false }, length: { minimum: 3 }

    scope :developer, -> { where(developer: true) }

    delegate :locale, to: :setting, allow_nil: true

    # broadcasts_to ->(_user) { "users" }, inserts_by: :prepend

    # :nocov:
    def active_for_authentication?
      super && !discarded?
    end

    # :nocov:

    # allow login via username or e-mail
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      where(conditions).where(
        ["LOWER(username) = :value OR LOWER(email) = :value", { value: login.strip.downcase }]
      ).first
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[username status name email]
    end
  end
end

# == Schema Information
#
# Table name: users
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
#  email                                    :string           default(""), not null, uniquely indexed
#  encrypted_password                       :string           default(""), not null
#  failed_attempts                          :integer          default(0), not null
#  last_sign_in_at                          :datetime
#  last_sign_in_ip                          :string
#  locked_at                                :datetime
#  name                                     :string           not null, indexed
#  remember_created_at                      :datetime
#  reset_password_sent_at                   :datetime
#  reset_password_token                     :string
#  sign_in_count                            :integer          default(0), not null
#  slug                                     :string           uniquely indexed
#  status(pending, active, deleted, banned) :enum             default("pending"), not null
#  unconfirmed_email                        :string
#  unlock_token                             :string
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
#  index_users_on_email         (email) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_name          (name) WHERE (discarded_at IS NOT NULL)
#  index_users_on_public_id     (public_id) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_slug          (slug) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_username      (username) UNIQUE WHERE (discarded_at IS NOT NULL)
#

