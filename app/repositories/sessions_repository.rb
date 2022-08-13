class SessionsRepository < ApplicationRepository
  ONLINE_TIME = 15.minutes

  def self.online?(resource:)
    return false unless resource.respond_to?(:last_online_at)

    resource.last_online_at >= ONLINE_TIME.ago
  end
end

