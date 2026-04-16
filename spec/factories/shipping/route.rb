FactoryBot.define do
  factory :shipping_route, class: "Shipping::Route" do
    starting_location factory: :location
    ending_location factory: :location
    road_days { 1 }
    road_cost { 1000 }
  end
end

