class Current < ActiveSupport::CurrentAttributes
  attribute :user, :stable
  attribute :request_id, :user_agent, :ip_address

  resets { Time.zone = nil }

  def user=(user)
    super
    self.stable = user.stable
    Time.zone = user.setting&.time_zone if user.setting&.time_zone
  end
end

