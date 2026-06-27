class Horses::Horse::Injurer
  attr_reader :horse, :date, :injury_type

  def initialize(horse:, date:, injury:)
    @horse = horse
    @date = date
    @injury_type = injury
  end

  def run
    ActiveRecord::Base.transaction do
      Horses::Racehorse::Injury.create!(
        horse:,
        date:,
        injury_type:,
        rest_date: date + rest_days.days
      )
      leg = pick_leg
      Horses::HistoricalInjury.create!(
        horse:,
        date:,
        injury_type:,
        leg:
      )
      horse.training_schedules_horse&.destroy
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Horse::InjuryNotification,
        user: horse.manager.user,
        params: {
          horse_id: horse.slug,
          horse_name: horse.name,
          injury: injury_type,
          leg:
        }
      )
    end
  end

  private

  def rest_days
    case injury_type
    when "heat"
      rand(3...5)
    when "swelling"
      rand(5...7)
    when "cut"
      rand(7...14)
    when "limping"
      rand(14...21)
    when "overheat"
      rand(30...65)
    when "bowed tendon"
      rand(60...95)
    when "broken leg"
      rand(365...435)
    end
  end

  def pick_leg
    case injury_type
    when "heat", "swelling", "cut", "limping", "bowed tendon", "broken leg"
      Config::Injuries.legs.sample.upcase
    end
  end
end

