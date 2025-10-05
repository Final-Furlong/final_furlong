FactoryBot.define do
  factory :legacy_stable, class: "Legacy::Stable" do
    availableBalance { 10_000 }
    date { Date.current }
    totalBalance { 20_000 }
  end
end

