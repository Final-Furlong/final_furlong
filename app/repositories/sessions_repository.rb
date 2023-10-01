class SessionsRepository < ApplicationRepository
  ONLINE_TIME = 15.minutes

  def self.online?(resource:)
    return false unless resource.respond_to?(:last_online_at)
    return false unless resource.last_online_at

    resource.last_online_at >= ONLINE_TIME.ago
  end

  def self.update_last_online(stable:)
    return unless stable
    return if stable.last_online_at && stable.last_online_at > 15.minutes.ago

    stable.update_columns(last_online_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end
end

