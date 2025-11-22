FactoryBot.define do
  factory :racehorse_shipment, class: "Shipping::RacehorseShipment" do
    horse { association :horse, :racehorse }
    starting_location { association :location }
    ending_location { association :location }
    departure_date { Date.current }
    arrival_date { Date.current + 3.days }
    mode { "road" }
    shipping_type { "track_to_track" }

    trait :past do
      after(:create) do |shipment|
        shipment.update_columns(departure_date: Date.current - 10.days, arrival_date: Date.current - 5.days)
      end
    end
  end

  factory :broodmare_shipment, class: "Shipping::BroodmareShipment" do
    horse { association :horse, :broodmare }
    starting_farm { association :stable }
    ending_farm { association :stable }
    departure_date { Date.current }
    arrival_date { Date.current + 3.days }
    mode { "road" }

    trait :past do
      after(:create) do |shipment|
        shipment.update_columns(departure_date: Date.current - 10.days, arrival_date: Date.current - 5.days)
      end
    end
  end
end

