module Racing
  class RaceScheduleUpdater
    def update_schedule
      max_date = Racing::RaceResult.where(date: ..Date.current).maximum(:date)
      max_number = Racing::RaceResult.where(date: max_date).maximum(:number)
      max_schedule_number = Racing::RaceSchedule.where(date: max_date).maximum(:number)
      if max_number.to_i < max_schedule_number.to_i
        max_date = Racing::RaceSchedule.where(date: ...max_date).maximum(:date)
      end
      max_date = Date.current if max_date && max_date > Date.current
      return unless max_date

      query = <<-SQL.squish
        SELECT day_number, date
        FROM  (
          SELECT DISTINCT ON (day_number) *
          FROM  race_schedules
          WHERE date <= '#{max_date}'
          ORDER  BY day_number ASC, date DESC
        ) p
        ORDER BY day_number ASC;
      SQL
      records = ActiveRecord::Base.connection.execute(query)
      records.each do |record|
        day_number = record["day_number"]

        if day_number == 1
          saturday = date_of_first_saturday(year: max_date.year + 1)
          wednesday = date_of_first_wednesday(year: max_date.year + 1)
          chosen_day = [saturday, wednesday].min
          Racing::RaceSchedule.where(date: ..max_date, day_number: 1).find_each do |schedule|
            schedule.update(date: chosen_day)
          end
        elsif day_number == 2
          last_date = Racing::RaceSchedule.where(day_number: 1).pick(:date)
          next_date = (last_date.wday == 6) ? last_date + 4.days : last_date + 3.days
          Racing::RaceSchedule.where(date: ..max_date, day_number: 2).find_each do |schedule|
            schedule.update(date: next_date)
          end
        else
          last_date = Racing::RaceSchedule.where(day_number: day_number - 2).pick(:date)
          next_date = last_date + 7.days
          if next_date.year == max_date.year + 1
            Racing::RaceSchedule.where(date: ..max_date, day_number:).find_each do |schedule|
              schedule.update(date: next_date)
            end
          end
        end
      end
    end

    private

    def date_of_first_saturday(year:)
      weekday = 6 # saturday
      base_date = Date.new(year, 1)
      base_weekday = base_date.wday
      if weekday == base_weekday
        base_date
      else
        difference = if (base_date + 7 - base_weekday + weekday).year < year
          7 - difference.abs
        else
          7 - base_weekday + weekday
        end
        difference -= 7 if difference > 7
        base_date + difference.days
      end
    end

    def date_of_first_wednesday(year:)
      weekday = 3 # wednesday
      base_date = Date.new(year, 1)
      base_weekday = base_date.wday
      if weekday == base_weekday
        base_date
      else
        difference = if (base_date + 7 - base_weekday + weekday).year < year
          7 - difference.abs
        else
          7 - base_weekday + weekday
        end
        difference -= 7 if difference > 7
        base_date + difference.days
      end
    end
  end
end

