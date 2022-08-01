class SessionsRepository < ApplicationRepository
  ONLINE_TIME = 15.minutes

  def self.online?(id:)
    CustomSession.where(user_id: id).exists?(["updated_at >= ?", ONLINE_TIME.ago])
  end
end
