module Accounts
  class User < ApplicationModel
    attribute :admin, Types::Bool
    attribute :confirmation_sent_at, Types::DateTime
    attribute :confirmation_token, Types::String
    attribute :confirmed_at, Types::DateTime
    attribute :current_sign_in_at, Types::DateTime
    attribute :discarded_at, Types::DateTime
    attribute :discourse_id, Types::Integer
    attribute :email, Types::String
    attribute :failed_attempts, Types::Integer
    attribute :last_sign_in_at, Types::DateTime
    attribute :last_sign_in_ip, Types::String
    attribute :locked_at, Types::DateTime
    attribute :name, Types::String
    attribute :remember_created_at, Types::DateTime
    attribute :reset_password_sent_at, Types::DateTime
    attribute :reset_password_token, Types::DateTime
    attribute :sign_in_count, Types::Integer
    attribute :slug, Types::String
    attribute :status, Types::Strict::String.enum("pending", "active", "deleted", "banned")
    attribute :unconfirmed_email, Types::String
    attribute :unlock_token, Types::String
    attribute :username, Types::String

    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime
  end
end

# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_created_at            (created_at)
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_discourse_id          (discourse_id) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

