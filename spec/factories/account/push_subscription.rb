FactoryBot.define do
  factory :push_subscription, class: "Account::PushSubscription" do
    auth_key { SecureRandom.alphanumeric(20) }
    endpoint { SecureRandom.alphanumeric(20) }
    p256dh_key { SecureRandom.alphanumeric(20) }
    user_agent { SecureRandom.alphanumeric(20) }
    user
  end
end

