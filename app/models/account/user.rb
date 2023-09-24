module Account
  class User < ApplicationRecord
    include Discard::Model

    attr_accessor :login

    USERNAME_LENGTH = 4
    PASSWORD_LENGTH = 8

    has_one :stable, dependent: :destroy
    has_one :activation, class_name: "Account::Activation", dependent: :delete
    has_one :setting, dependent: :delete

    # Include default devise modules. Others available are:
    # :omniauthable
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable,
      :confirmable, :lockable, :timeoutable, :trackable

    enum status: { pending: "pending", active: "active", deleted: "deleted", banned: "banned" }

    validates :username, :status, :name, presence: true
    validates :admin, inclusion: { in: [true, false] }
    validates :username, uniqueness: { case_sensitive: false }

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
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string           indexed
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discarded_at           :datetime         indexed
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  slug                   :string           indexed
#  status                 :enum             default("pending"), not null
#  unconfirmed_email      :string
#  unlock_token           :string           indexed
#  username               :string           not null
#  created_at             :datetime         not null, indexed
#  updated_at             :datetime         not null
#  discourse_id           :integer          indexed
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_created_at            (created_at) WHERE (discarded_at IS NULL)
#  index_users_on_discarded_at          (discarded_at) WHERE (discarded_at IS NULL)
#  index_users_on_discourse_id          (discourse_id) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_email                 (email) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_lowercase_username    (lower((username)::text)) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_slug                  (slug) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_unlock_token          (unlock_token) UNIQUE WHERE (discarded_at IS NULL)
#

