module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :true_user
    impersonates :user, method: :current_user, with: ->(id) { Account::User.find_by(id:) }

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if verified_user = User.find_by(id: cookies.encrypted[:user_id])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
