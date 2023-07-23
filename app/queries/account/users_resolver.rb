module Account
  class UsersResolver < ::ApplicationQuery
    property :username

    def user
      Account::User.find_by(username:)
    end

    def authorized?
      current_user.present?
    end
  end
end

