module Horses
  class AutoBoardingUpdater
    def call
      horses_updated = 0
      Horses::Boarding.where(start_date: ..(Date.current - Config::Boarding.max_yearly_days.days)).where(end_date: nil).find_each do |boarding|
        Horses::BoardingUpdater.new.stop_boarding(boarding:)
        horses_updated += 1
      end
      Horses::Boarding.current.find_each do |boarding|
        start_date = [Date.new(Date.current.year, 1, 1), boarding.start_date].max
        end_date = Date.current
        current_year_days = (end_date - start_date).to_i

        horse = boarding.horse
        current_year_days += horse.boardings.current_year.where(location: boarding.location).sum(:days)
        if current_year_days >= Config::Boarding.max_yearly_days
          Horses::BoardingUpdater.new.stop_boarding(boarding:)
          horses_updated += 1
        end
      end
      stables_updated = 0
      Account::Stable.joins(horses: :current_boarding).find_each do |stable|
        num_boarded = stable.horses.where.associated(:current_boarding).uniq.count

        stable.available_balance -= num_boarded * Config::Boarding.daily_fee
        stable.save
        stables_updated += 1
      end
      { horses_updated:, stables_updated: }
    end
  end
end

