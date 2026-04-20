class Racing::PreRaceJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  def perform
    horses = 0
    races = 0

    tomorrow = Date.tomorrow

    step :process do |step|
      entries = Racing::RaceEntry.where(date: tomorrow).needs_pre_race
      Racing::RaceSchedule.where(date: tomorrow).joins(:entries).where(entries:).find_each(start: step.cursor) do |race|
        index = 1
        taken_jockey_ids = race.entries.where.not(jockey: nil).pluck(:jockey_id)
        race.entries.order("RANDOM()").each do |entry|
          taken_jockey_ids << process_entry(entry, race, index, taken_jockey_ids)
          horses += 1
          index += 1
        end
        races += 1

        step.advance! from: race.id
      end
    end
    store_job_info(outcome: { horses:, races: })
  end

  private

  def process_entry(entry, race, index, taken_jockey_ids)
    attrs = { post_parade: index, first_jockey: nil, second_jockey: nil, third_jockey: nil }
    attrs[:jockey] = pick_jockey(entry, race, taken_jockey_ids) if entry.jockey.blank?
    attrs[:odd] = pick_odd(entry, race) if entry.odd.blank?
    entry.update(attrs)
    attrs[:weight] = pick_weight(entry, race) unless entry.weight.to_i.zero?
    entry.update!(attrs)
    entry.jockey_id
  end

  def pick_odd(entry, race)
    horse = entry.horse
    recent_finishes = Racing::RaceResultHorse.where(horse:).joins(:race)
      .merge(Racing::RaceResult.min_distance(race.distance - 1.0).max_distance(race.distance + 1.0).ordered_by_date(:desc)).limit(5)
    if recent_finishes.empty?
      odds = (race.entries_count * 0.8).round.pow(2)
    else
      total_points = 0
      race.entries_count.pow(2)
      recent_finishes.each do |finish|
        points = 0
        recent_race = finish.race
        if finish.finish_position <= 4
          points = (5 - finish.finish_position) * 10
          case recent_race.race_type
          when "claiming"
            points *= 1.5
          when "stakes"
            case recent_race.grade
            when "Ungraded"
              points *= 2.5
            when "Grade 3"
              points *= 3
            when "Grade 2"
              points *= 3.5
            when "Grade 1"
              points *= 4
            end
          else
            if recent_race.race_type.to_s.downcase.include?("allowance")
              points *= 2
            end
          end
          if recent_race.horses_count == 14
            points += 8
          elsif recent_race.horses_count == 13
            points += 6
          elsif recent_race.horses_count == 12
            points += 4
          elsif recent_race.horses_count == 11
            points += 2
          end
        end
        points /= 2 if race.track_surface.surface != recent_race.track_surface.surface
        points /= 2 if race.distance != recent_race.distance
        points /= 2 if race.distance != recent_race.distance
        points /= 2 if race.date < 1.year.ago
        total_points += points
      end
      average_points = total_points.fdiv(recent_finishes.count)
      required_points = if race.race_type == "claiming"
        60
      elsif race.race_type.to_s.downcase.include?("allowance")
        80
      elsif race.race_type == "stakes"
        case race.grade
        when "Ungraded"
          100
        when "Grade 3"
          120
        when "Grade 2"
          140
        when "Grade 1"
          160
        end
      else
        40
      end
      percent = if average_points > required_points
        (required_points + average_points).fdiv(required_points)
      else
        ((average_points - required_points) + required_points).fdiv(required_points)
      end
      odds = (race.entries_count * 0.8 * percent).round(1)
    end

    pick_odds(entry, race, odds)
  end

  def pick_odds(entry, race, odds)
    confidence_score = confidence(entry, race)
    display = if odds <= 1
      if confidence_score > 50
        "1:1"
      elsif confidence_score > 25
        "6:5"
      else
        "4:3"
      end
    elsif odds <= 1.2
      if confidence_score > 50
        "1:1"
      elsif confidence_score > 25
        "4:3"
      else
        "7:5"
      end
    elsif odds <= 1.3
      if confidence_score > 75
        "1:1"
      elsif confidence_score > 50
        "6:5"
      elsif confidence_score > 25
        "7:5"
      else
        "3:2"
      end
    elsif odds <= 1.4
      if confidence_score > 75
        "6:5"
      elsif confidence_score > 50
        "4:3"
      elsif confidence_score > 25
        "3:2"
      else
        "8:5"
      end
    elsif odds <= 1.5
      if confidence_score > 75
        "4:3"
      elsif confidence_score > 50
        "7:5"
      elsif confidence_score > 25
        "8:5"
      else
        "9:5"
      end
    elsif odds <= 1.6
      if confidence_score > 75
        "7:5"
      elsif confidence_score > 50
        "3:2"
      elsif confidence_score > 25
        "9:5"
      else
        "2:1"
      end
    elsif odds <= 1.8
      if confidence_score > 75
        "3:2"
      elsif confidence_score > 50
        "8:5"
      elsif confidence_score > 25
        "2:1"
      else
        "3:1"
      end
    elsif odds <= 2
      if confidence_score > 75
        "8:5"
      elsif confidence_score > 50
        "9:5"
      elsif confidence_score > 25
        "3:1"
      else
        "4:1"
      end
    elsif odds <= 3
      if confidence_score > 75
        "8:5"
      elsif confidence_score > 50
        "2:1"
      elsif confidence_score > 25
        "4:1"
      else
        "5:1"
      end
    elsif odds <= 4
      if confidence_score > 75
        "2:1"
      elsif confidence_score > 50
        "3:1"
      elsif confidence_score > 25
        "5:1"
      else
        "10:1"
      end
    elsif odds <= 5
      if confidence_score > 75
        "3:1"
      elsif confidence_score > 50
        "4:1"
      elsif confidence_score > 25
        "10:1"
      else
        "20:1"
      end
    elsif odds <= 10
      if confidence_score > 75
        "4:1"
      elsif confidence_score > 50
        "5:1"
      elsif confidence_score > 25
        "20:1"
      else
        "30:1"
      end
    elsif odds <= 20
      if confidence_score > 75
        "5:1"
      elsif confidence_score > 50
        "10:1"
      elsif confidence_score > 25
        "30:1"
      else
        "40:1"
      end
    elsif odds <= 30
      if confidence_score > 75
        "10:1"
      elsif confidence_score > 50
        "20:1"
      elsif confidence_score > 25
        "40:1"
      else
        "50:1"
      end
    elsif odds <= 40
      if confidence_score > 75
        "20:1"
      elsif confidence_score > 50
        "30:1"
      elsif confidence_score > 25
        "50:1"
      else
        "60:1"
      end
    elsif odds <= 50
      if confidence_score > 75
        "30:1"
      elsif confidence_score > 50
        "40:1"
      elsif confidence_score > 25
        "60:1"
      else
        "70:1"
      end
    elsif odds <= 60
      if confidence_score > 75
        "40:1"
      elsif confidence_score > 50
        "50:1"
      elsif confidence_score > 25
        "70:1"
      else
        "80:1"
      end
    elsif odds <= 70
      if confidence_score > 75
        "50:1"
      elsif confidence_score > 50
        "60:1"
      elsif confidence_score > 25
        "80:1"
      else
        "80:1"
      end
    elsif odds <= 80
      if confidence_score > 75
        "60:1"
      elsif confidence_score > 50
        "70:1"
      elsif confidence_score > 25
        "90:1"
      else
        "99:1"
      end
    elsif odds <= 90
      if confidence_score > 75
        "70:1"
      elsif confidence_score > 50
        "80:1"
      else
        "99:1"
      end
    elsif confidence_score > 75
      "80:1"
    elsif confidence_score > 50
      "90:1"
    else
      "99:1"
    end

    Racing::Odd.find_by(display:)
  end

  def confidence(entry, race)
    horse = entry.horse
    max_confidence = 100
    last_race_date = horse.race_metadata.last_raced_at
    if last_race_date
      confidence = horse.workouts.where("date > ?", last_race_date).where.not(confidence: [0, nil]).average(:confidence)
    end
    stats = horse.racing_stats
    confidence ||= (stats.pissy * (stats.courage / 2)) * 10
    if stats.energy > 80 && stats.energy < 91
      confidence -= rand(1..5)
    elsif stats.energy > 70 && stats.energy < 81
      confidence -= rand(6..10)
    elsif stats.energy > 60 && stats.energy < 71
      confidence -= rand(11..15)
    elsif stats.energy > 50 && stats.energy < 61
      confidence -= rand(16..20)
    elsif stats.energy < 51
      confidence -= rand(21..25)
    end

    jock_relationship = horse.jockey_relationships.find_by(jockey: entry.jockey)
    xp = jock_relationship&.experience.to_i
    happy = jock_relationship&.happiness.to_i
    if xp > 90
      confidence += rand(16..20)
    elsif xp > 80
      confidence += rand(11..15)
    elsif xp > 70
      confidence += rand(6..10)
    elsif xp > 60
      confidence += rand(1..5)
    elsif xp > 50
      confidence -= rand(1..5)
    elsif xp > 40
      confidence -= rand(6..10)
    elsif xp > 30
      confidence -= rand(11..15)
    elsif xp > 20
      confidence -= rand(16..20)
    elsif xp > 10
      confidence -= rand(21..25)
    elsif xp > 0
      confidence -= rand(26..30)
    else
      confidence += rand(-15..10)
    end

    if happy > 90
      confidence += rand(16..20)
    elsif happy > 80
      confidence += rand(11..15)
    elsif happy > 70
      confidence += rand(6..10)
    elsif happy > 60
      confidence += rand(1..5)
    elsif happy > 50
      confidence -= rand(1..5)
    elsif happy > 40
      confidence -= rand(6..10)
    elsif happy > 30
      confidence -= rand(11..15)
    elsif happy > 20
      confidence -= rand(16..20)
    elsif happy > 10
      confidence -= rand(21..25)
    elsif happy > 0
      confidence -= rand(26..30)
    else
      confidence += rand(-15..10)
    end
    if stats.xp_current > 80
      confidence += rand(11..15)
    elsif stats.xp_current > 60
      confidence += rand(6..10)
    elsif stats.xp_current > 40
      confidence += rand(-5..5)
    elsif stats.xp_current > 20
      confidence -= rand(6..10)
    else
      confidence -= rand(11..15)
    end
    stat = stats.send(race.track_surface.surface.downcase.to_sym)
    case stat
    when 10
      confidence += rand(16..20)
    when 9
      confidence += rand(11..15)
    when 8
      confidence += rand(6..10)
    when 7
      confidence += rand(1..5)
    when 6
      confidence -= rand(1..5)
    when 5
      confidence -= rand(6..10)
    when 4
      confidence -= rand(11..15)
    when 3
      confidence -= rand(16..20)
    when 2
      confidence -= rand(21..25)
    when 1
      confidence -= rand(26..30)
    end
    final_confidence = (confidence.fdiv(max_confidence) * 100).round
    final_confidence.clamp(1, 100)
  end

  def pick_jockey(entry, race, taken_jockey_ids)
    if entry.first_jockey_id
      first_jock = Racing::Jockey.find_by(id: entry.first_jockey_id)
      if taken_jockey_ids.exclude?(first_jock.id) && (race.jump? || first_jock.jockey_type == "flat")
        return first_jock
      elsif entry.second_jockey_id
        second_jock = Racing::Jockey.find_by(id: entry.second_jockey_id)
        if taken_jockey_ids.exclude?(second_jock.id) && (race.jump? || second_jock.jockey_type == "flat")
          return second_jock
        elsif entry.third_jockey_id
          third_jock = Racing::Jockey.find_by(id: entry.third_jockey_id)
          if taken_jockey_ids.exclude?(third_jock.id) && (race.jump? || third_jock.jockey_type == "flat")
            return third_jock
          end
        end
      end
    end
    race_type = race.jump? ? :jump : :flat
    Racing::Jockey.where.not(id: taken_jockey_ids).send(race_type).order("RANDOM()").first
  end

  def pick_weight(entry, race)
    horse = entry.horse
    boys = race.entries.joins(:horse).merge(Horses::Horse.not_female).exists?
    girls = race.entries.joins(:horse).merge(Horses::Horse.female).exists?
    younger_age = race.min_age
    younger = race.entries.joins(:horse).merge(Horses::Horse.max_age(younger_age)).exists?
    older = race.entries.joins(:horse).merge(Horses::Horse.min_age(younger_age.to_i + 1)).exists?

    weight = case race.race_type
    when "stakes"
      if race.name.downcase.include?(" handicap")
        min_weight = Config::Racing.weights[:stakes_handicap_min]
        max_weight = Config::Racing.weights[:stakes_handicap_max]
        percent = (100 - entry.odd.value).fdiv(99).round(2)
        (min_weight + (max_weight - min_weight * percent)).round
      else
        Config::Racing.weights[:stakes]
      end
    when "maiden"
      Config::Racing.weights[:maiden]
    when "claiming"
      if race.claiming_price <= 15000
        Config::Racing.weights[:claiming_15000]
      elsif race.claiming_price <= 40000
        Config::Racing.weights[:claiming_40000]
      else
        Config::Racing.weights[:claiming]
      end
    else
      Config::Racing.weights[race.race_type.downcase.to_sym]
    end
    raise [weight, race.race_type, race.claiming_price].inspect if weight.blank?

    if boys && girls && horse.female?
      weight -= Config::Racing.weights[:female_bonus]
    end
    if younger && older && horse.age == younger_age
      weight -= Config::Racing.weights[:younger_bonus]
    end

    maiden_bonus = case race.race_type
    when "allowance"
      Config::Racing.weights[:maiden_bonus_open_allowance]
    when "stakes"
      Config::Racing.weights[:maiden_bonus_stakes]
    else
      if race.race_type.downcase.include?("allowance")
        Config::Racing.weights[:maiden_bonus_non_open_allowance]
      end
    end
    if maiden_bonus && horse.lifetime_race_record&.wins.to_i.zero?
      weight -= maiden_bonus
    end

    if entry.jockey.status == "apprentice"
      weight -= Config::Racing.weights[:apprentice_jockey_bonus]
    end
    weight
  end
end

