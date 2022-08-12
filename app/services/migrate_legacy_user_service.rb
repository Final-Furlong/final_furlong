class MigrateLegacyUserService
  attr_reader :legacy_user

  def initialize(legacy_user_id)
    @legacy_user = LegacyUser.find(legacy_user_id)
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return if User.exists?(email: legacy_user.email)

    password = generate_password
    user_status = status(legacy_user)
    user = nil
    User.transaction do
      user = User.create!(
        admin: %w[Shanthi FFadmin].include?(legacy_user.username),
        confirmed_at: Time.current,
        email: legacy_user.email,
        last_sign_in_at: from_game_date(legacy_user.last_login),
        last_sign_in_ip: legacy_user.ip,
        name: legacy_user.name,
        status: status(legacy_user),
        unconfirmed_email: legacy_user.email,
        username: legacy_user.username,
        created_at: from_game_date(legacy_user.join_date) || Time.current,
        updated_at: Time.current,
        discourse_id: legacy_user.discourse_id,
        password:,
        password_confirmation: password,
        discarded_at: user_status == User.statuses[:deleted] ? Time.current : nil
      )
      Stable.create!(
        legacy_id: legacy_user.id,
        name: legacy_user.stable_name,
        user:,
        created_at: user.created_at
      )
    end
    user
  end

  private

    def from_game_date(value)
      case value
      when Date
        value.from_game_date
      when DateTime
        value.from_game_time
      else
        Date.parse_safely(value)&.from_game_date
      end
    end

    def generate_password
      SecureRandom.base64
    end

    def status(legacy_user)
      case legacy_user.status
      when "A"
        User.statuses[:pending]
      when "CW"
        User.statuses[:active]
      else
        User.statuses[:deleted]
      end
    end
end
