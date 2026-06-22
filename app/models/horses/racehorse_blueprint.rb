module Horses
  class RacehorseBlueprint < ::Blueprinter::Base
    identifier :id

    fields :name, :gender, :status, :owner_id, :breeder_id, :manager_id,
      :date_of_birth, :age, :date_of_death, :sire_id, :dam_id

    field :manager_name do |horse, options|
      horse.manager.name
    end

    field :owner_name do |horse, options|
      horse.owner.name
    end

    field :breeder_name do |horse, options|
      horse.breeder.name
    end

    field :last_race_date do |horse, options|
      horse.race_results.order(date: :desc).first&.date
    end

    field :confidence do |horse, options|
      last_race_date = horse.race_results.order(date: :desc).first&.date
      last_race_date ?
        horse.workouts.where("date > ?", last_race_date).where("confidence > ?", 0).average(:confidence)
        : nil
    end

    field :race_confidence do |horse, options|
      recent_races = horse.race_result_finishes.joins(:race).includes(:race).order(race: { date: :desc }).limit(10)
      last_race_type = ""
      last_finish_position = 100
      index = 1
      total_points = 0
      total_max_points = 0
      recent_races.each do |finish|
        race = finish.race
        field_size = race.horses_count
        points = (finish.finish_position == field_size) ? 1 : field_size * 2 - 2 * (finish.finish_position - 1)
        max_points = field_size * 2
        case race.race_type
        when "maiden"
          if last_race_type == "claiming"
            points += 5 if last_finish_position <= 4
            max_points += 5
          elsif last_race_type.downcase.include?("allowance")
            points += 10 if last_finish_position <= 4
            max_points += 10
          elsif last_race_type == "stakes"
            points += 15 if last_finish_position <= 4
            max_points += 15
          end
        when "claiming"
          if last_race_type == "maiden"
            points -= 5 if last_finish_position > 4
          elsif last_race_type.downcase.include?("allowance")
            points += 5 if last_finish_position <= 4
            max_points += 5
          elsif last_race_type == "stakes"
            points += 10 if last_finish_position <= 4
            max_points += 10
          end
        when "starter_allowance", "nw1_allowance", "nw2_allowance", "nw3_allowance", "allowance"
          if last_race_type == "maiden"
            points -= 10 if last_finish_position > 4
          elsif last_race_type == "claiming"
            points -= 5 if last_finish_position > 4
          elsif last_race_type == "stakes"
            points += 5 if last_finish_position <= 4
            max_points += 5
          end
        when "stakes"
          if last_race_type == "maiden"
            points -= 15 if last_finish_position > 4
          elsif last_race_type == "claiming"
            points -= 10 if last_finish_position > 4
          elsif last_race_type.include? "allowance"
            points -= 5 if last_finish_position > 4
          end
        end
        case index
        when 1
          points *= 6
        when 2
          points *= 4
        when 3
          points *= 3
        when 4
          points *= 2
        end
        total_points += points
        total_max_points += max_points
        index += 1
        last_race_type = race.race_type
        last_finish_position = finish.finish_position
      end
      total_max_points.zero? ? 0 : (total_points.fdiv(total_max_points) * 100).round
    end

    association :racing_stats, blueprint: ::Racing::RacingStatsBlueprint

    association :next_race_entry, blueprint: ::Racing::RaceEntryBlueprint, name: :race_entry

    association :next_jockey_relationship, blueprint: ::Racing::HorseJockeyRelationshipBlueprint, name: :jockey_relationship do |horse, options|
      horse.jockey_relationships.find_by(jockey: horse.next_race_entry&.jockey)
    end

    association :current_injuries, blueprint: ::Racing::InjuryBlueprint
  end
end

