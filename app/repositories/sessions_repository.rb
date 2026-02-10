class SessionsRepository < ApplicationRepository
  def self.online?(resource:)
    return false unless resource.respond_to?(:last_online_at)
    return false unless resource.last_online_at

    recently_online?(stable: resource)
  end

  def self.update_last_online(stable:)
    return unless stable
    return if recently_online?(stable:)

    stable.update_columns(last_online_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end

  def self.recently_online?(stable:)
    return false unless stable.last_online_at

    stable.last_online_at > Config::Game.online_minutes.minutes.ago
  end
end

