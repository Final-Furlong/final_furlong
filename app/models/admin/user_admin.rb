# typed: false

module Admin
  module UserAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          exclude_fields :id, :admin, :name, :discourse_id, :remember_created_at,
                         :reset_password_sent_at, :reset_password_token, :created_at, :updated_at,
                         :current_sign_in_ip, :last_sign_in_ip, :last_sign_in_at, :confirmation_token,
                         :confirmed_at, :confirmation_sent_at, :failed_attempts, :unlock_token,
                         :unconfirmed_email, :locked_at, :slug, :sign_in_count

          field :status do # (1)
            searchable false
            filterable true
          end

          scopes { %w[active pending deleted banned] }
        end
      end
    end
  end
end
