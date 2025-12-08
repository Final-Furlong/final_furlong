module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :true_user
    impersonates :user, method: :current_user, with: ->(id) { Account::User.find_by(id:) }

    def connect
      self.user = swallow_warden_throws { find_verified_user }
      reject_unauthorized_connection unless current_user
      logger.add_tags "ActionCable", "User #{current_user.id}"
    end

    protected

    def find_verified_user
      env["warden"].user
    end

    def swallow_warden_throws
      catch(:warden) do
        result = yield
        # This might look pointless, but it's not. We only get here if we don't throw, so we need to return early to
        # expose the yielded value to the caller as opposed to nil
        return result
      end
      nil
    end
  end
end

