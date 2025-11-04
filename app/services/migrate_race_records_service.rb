class MigrateRaceRecordsService # rubocop:disable Metrics/ClassLength
  # rubocop:disable Rails/Output
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    query = Horses::Horse.where.associated(:race_result_finishes).where.missing(:race_records).distinct
    query.find_each(cursor: [:id], order: [:asc]) do |horse|
      start_year = horse.date_of_birth.year + 2
      (start_year..Date.current.year).each do |year|
        if horse.race_results.by_year(year).exists?
          %w[dirt turf steeplechase].each do |track|
            if horse.race_results.by_year(year).by_track(track).exists?
              record = Racing::RaceRecord.find_or_initialize_by(
                horse:,
                year:,
                result_type: track
              )
              attrs = { starts: horse.race_results.by_year(year).by_track(track).count }
              attrs[:wins] = horse.race_result_finishes.joins(:race).by_finish(1).merge(Racing::RaceResult.by_year(year).by_track(track)).count
              attrs[:seconds] = horse.race_result_finishes.joins(:race).by_finish(2).merge(Racing::RaceResult.by_year(year).by_track(track)).count
              attrs[:thirds] = horse.race_result_finishes.joins(:race).by_finish(3).merge(Racing::RaceResult.by_year(year).by_track(track)).count
              attrs[:fourths] = horse.race_result_finishes.joins(:race).by_finish(4).merge(Racing::RaceResult.by_year(year).by_track(track)).count
              attrs[:stakes_starts] = horse.race_results.by_year(year).by_track(track).by_type("stakes").count
              if attrs[:stakes_starts] > 0
                attrs[:stakes_wins] = horse.race_result_finishes.joins(:race).by_finish(1).merge(Racing::RaceResult.by_year(year).by_track(track).by_type("stakes")).count if attrs[:wins].positive?
                attrs[:stakes_seconds] = horse.race_result_finishes.joins(:race).by_finish(2).merge(Racing::RaceResult.by_year(year).by_track(track).by_type("stakes")).count if attrs[:seconds].positive?
                attrs[:stakes_thirds] = horse.race_result_finishes.joins(:race).by_finish(3).merge(Racing::RaceResult.by_year(year).by_track(track).by_type("stakes")).count if attrs[:thirds].positive?
                attrs[:stakes_fourths] = horse.race_result_finishes.joins(:race).by_finish(4).merge(Racing::RaceResult.by_year(year).by_track(track).by_type("stakes")).count if attrs[:fourths].positive?
              end
              attrs[:points] ||= 0
              attrs[:earnings] ||= 0
              horse.race_result_finishes.joins(:race).by_max_finish(5).merge(Racing::RaceResult.by_year(year).by_track(track)).each do |finish|
                race = finish.race
                attrs[:points] += points(race.date.year, race.race_type, finish.finish_position)
                attrs[:earnings] += race.purse * money_percent(race.date.year, race.race_type, finish.finish_position)
              end
              record.assign_attributes(attrs)
              record.save!
            end
          end
        end
      end
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end

  # rubocop:enable Rails/Output

  private

  def points(year, type, position)
    if year >= 2004
      points_2004(type.to_s.downcase, position)
    else
      points_older(type.to_s.downcase, position)
    end
  end

  def money_percent(year, type, position)
    if year >= 2004
      money_2004(position)
    else
      money_older(type.to_s.downcase, position)
    end
  end

  def money_2004(position)
    case position
    when 1 then 0.6
    when 2 then 0.2
    when 3 then 0.1
    when 4 then 0.07
    when 5 then 0.03
    else 0
    end
  end

  def points_older(type, position)
    if type == "stakes"
      case position
      when 1 then 84
      when 2 then 42
      when 3 then 21
      when 4 then 14
      else 0
      end
    elsif type.include?("allowance")
      case position
      when 1 then 21
      when 2 then 14
      when 3 then 7
      else 0
      end
    else
      case position
      when 1 then 4
      when 2 then 2
      when 3 then 1
      else 0
      end
    end
  end

  def money_older(type, position)
    if type == "stakes"
      case position
      when 1 then 0.75
      when 2 then 0.2
      when 3 then 0.05
      else 0
      end
    else
      case position
      when 1 then 0.5
      when 2 then 0.4
      when 3 then 0.1
      else 0
      end
    end
  end

  def points_2004(type, position)
    if type == "stakes"
      case position
      when 1 then 42
      when 2 then 21
      when 3 then 10
      when 4 then 7
      else 0
      end
    elsif type.include?("allowance")
      case position
      when 1 then 10
      when 2 then 7
      when 3 then 3
      else 0
      end
    else
      case position
      when 1 then 2
      when 2 then 1
      else 0
      end
    end
  end
end

