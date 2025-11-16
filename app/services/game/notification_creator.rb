module Game
  class NotificationCreator
    def create_notification(type:, user:, params:)
      type.create!(user:, params:)
    end
  end
end

