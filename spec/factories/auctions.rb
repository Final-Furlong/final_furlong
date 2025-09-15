FactoryBot.define do
  factory :auction do
    auctioneer factory: :stable
    title { SecureRandom.alphanumeric(20) }
    start_time { Date.current + 10.days }
    end_time { Date.current + 20.days }
    racehorse_allowed_2yo { true }
    racehorse_allowed_3yo { true }
    racehorse_allowed_older { true }

    trait :allow_reserve do
      reserve_pricing_allowed { true }
    end

    trait :allow_outside do
      outside_horses_allowed { true }
    end

    trait :with_spending_cap do
      transient do
        spending_cap { 100_000 }
      end

      after(:build) do |auction, context|
        auction.spending_cap_per_stable = context.spending_cap
      end
    end
  end
end

