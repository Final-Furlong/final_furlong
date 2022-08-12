class SessionsRepository < ApplicationRepository
  def self.online?(*)
    false
  end
end
