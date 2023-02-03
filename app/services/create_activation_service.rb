class CreateActivationService
  attr_reader :user

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def call
    return if Account::Activation.exists?(user:)

    Account::Activation.create!(user:, token: Digest::MD5.hexdigest(user.email), activated_at: nil)
    user
  end
end

