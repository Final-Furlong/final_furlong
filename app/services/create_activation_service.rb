class CreateActivationService
  attr_reader :user, :repo

  def initialize(user_id)
    @user = Account::User.find(user_id)
    @repo = Account::ActivationsRepository.new(model: Account::Activation)
  end

  def call
    return if Account::Activation.exists?(user:)

    repo.create!(user:, token: Digest::MD5.hexdigest(user.email), activated_at: nil)
    user
  end
end

