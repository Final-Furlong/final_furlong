module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :true_user
    impersonates :user, method: :current_user, with: ->(id) { Account::User.find_by(id:) }

    def connect
      self.current_user = swallow_warden_throws { env["warden"].user }
      reject_unauthorized_connection unless current_user
      logger.add_tags "ActionCable", "User #{current_user.id}"
    end

    protected

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

