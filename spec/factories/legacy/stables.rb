FactoryBot.define do
  factory :legacy_stable, class: "Legacy::Stable" do
    id { Faker::Number.number(digits: 5) }
    availableBalance { 10_000 }
    date { Date.current }
    totalBalance { 20_000 }
  end
end

