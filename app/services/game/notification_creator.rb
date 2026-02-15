module Game
  class NotificationCreator
    def create_notification(type:, user:, params:)
      return if user.username == Config::Game.username

      type.create!(user:, params:)
    end
  end
end

