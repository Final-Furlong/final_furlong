module Game
  class BreedingSeason
    def self.start_date(year = Date.current.year)
      Date.new(year, 2, 15)
    end

    def self.end_date(year = Date.current.year)
      Date.new(year, 8, 31)
    end

    def self.breeding_season_date?(date)
      date.between?(start_date(date.year), end_date(date.year))
    end

    def self.pre_breeding_season_date?(date, days_before = 0)
      first_date = start_date(date.year) - days_before.days
      date.between?(first_date, start_date(date.year))
    end

    def self.next_season_start_date
      return start_date if start_date > Date.current

      start_date(Date.current.year + 1)
    end
  end
end

