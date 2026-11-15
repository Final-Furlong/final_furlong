class Horses::UpdateAgesJob < ApplicationJob
  queue_as :latency_30s

  retry_on ActiveRecord::RecordInvalid

  def perform
    horses = 0
    game_stable = Accounts::Stable.find_by(name: Config::Game.stable)
    Horses::Horse.where.not(state: ["unborn", "deceased"]).find_each do |horse|
      horse.age = Date.current.year - horse.date_of_birth.year
      if horse.age >= 2 && horse.type == "Horses::Horse::Foal"
        horse.type = "Horses::Horse::Racehorse"
      end
      if horse.age >= 4
        if horse.gender == "filly"
          horse.gender = "mare"
        elsif horse.gender == "colt"
          horse.gender = "stallion"
        end
        if horse.owner == game_stable && horse.active? && horse.racehorse?
          if horse.age >= 10 && horse.female?
            horse.type = "Horses::Horse::Broodmare"
          elsif horse.age > 10
            horse.state = "retired"
          end
        end
      end
      horse.save
      horses += 1
    end
    store_job_info(outcome: { horses: })
  end
end

