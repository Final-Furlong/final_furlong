module Dashboard
  module Horse
    class StudNomination
      attr_reader :horse, :years

      def initialize(horse:)
        @horse = horse
        crop_years = horse.stud_foals.born.group("DATE_PART('Year', date_of_birth)").count.sort
        @years = []
        crop_years.map do |info|
          year = info.first.to_i
          data = {
            year: info.first.to_i,
            foals: info.last.to_i,
            racers: 0,
            winners: 0,
            stakes_winners: 0,
            status: horse.stud_nominations.exists?(year:) ? :nominated : :not_nominated
          }
          if year <= Date.current.year - 2 && info.last.to_i.positive?
            data[:racers] = horse.stud_foals.with_yob(year).where.associated(:lifetime_race_record).count
            if data[:racers] > 0
              data[:winners] = horse.stud_foals.with_yob(year).joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.winner).count
              if data[:winners] > 0
                data[:stakes_winners] = horse.stud_foals.with_yob(year).joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.stakes_winner).count
              end
            end
          end
          @years << data
        end
        if horse.breedings.not_denied.exists?(year: Date.current.year)
          @years << {
            year: Date.current.year + 1,
            foals: horse.breedings.not_denied.count,
            racers: 0,
            winners: 0,
            stakes_winners: 0,
            status: horse.stud_nominations.exists?(year: Date.current.year + 1) ? :nominated : :not_nominated
          }
        end
      end
    end
  end
end

