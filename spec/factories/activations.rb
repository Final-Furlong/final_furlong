FactoryBot.define do
  factory :activation do
    token { SecureRandom.uuid }
    user

    trait :unactivated do
      activated_at { nil }
    end

    trait :activated do
      activated_at { Time.current }
    end
  end
end
