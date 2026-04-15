FactoryBot.define do
  factory :race_entry, class: "Racing::RaceEntry" do
    horse
    race factory: :race_schedule
    date { race.date }
  end
end

