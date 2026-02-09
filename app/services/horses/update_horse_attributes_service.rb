module Horses
  class UpdateHorseAttributesService # rubocop:disable Metrics/ClassLength
    def call(horse:)
      update_horse(horse)
    end

    private

    def update_horse(horse)
      horse_attributes = horse.horse_attributes || horse.build_horse_attributes
      record = horse.lifetime_race_record
      track_record = if record.blank?
        "Unraced"
      elsif record.stakes_wins > 1 && record.stakes_places > 1
        "Mult. Stakes Winner, Mult. Stakes Placed"
      elsif record.stakes_wins > 1 && record.stakes_places == 1
        "Mult. Stakes Winner, Stakes Placed"
      elsif record.stakes_wins == 1 && record.stakes_places > 1
        "Stakes Winner, Mult. Stakes Placed"
      elsif record.stakes_wins == 1 && record.stakes_places == 0
        "Stakes Winner, Stakes Placed"
      elsif record.stakes_wins > 1
        "Mult. Stakes Winner"
      elsif record.stakes_wins == 1
        "Stakes Winner"
      elsif record.stakes_places > 1
        "Mult. Stakes Placed"
      elsif record.stakes_places == 1
        "Stakes Placed"
      elsif record.wins > 1 && record.places > 1
        "Mult. Winner, Mult. Placed"
      elsif record.wins > 1 && record.places == 1
        "Mult. Winner, Placed"
      elsif record.wins == 1 && record.places > 1
        "Winner, Mult. Placed"
      elsif record.wins == 1 && record.places == 1
        "Winner, Placed"
      elsif record.wins > 1
        "Mult. Winner"
      elsif record.wins == 1
        "Winner"
      elsif record.places > 1
        "Mult. Placed"
      elsif record.places == 1
        "Placed"
      else
        "Unplaced"
      end
      if record&.earnings&.>= 2_000_000
        track_record += ", Multi-Millionaire"
      elsif record&.earnings&.>= 1_000_000
        track_record += ", Millionaire"
      end
      points = record&.points.to_i
      title = if points >= Config::Racing.dig(:title_points, :final_furlong)
        "Final Furlong"
      elsif points >= Config::Racing.dig(:title_points, :world)
        "World"
      elsif points >= Config::Racing.dig(:title_points, :international)
        "International"
      elsif points >= Config::Racing.dig(:title_points, :national)
        "National"
      elsif points >= Config::Racing.dig(:title_points, :grand)
        "Grand"
      elsif points >= Config::Racing.dig(:title_points, :normal)
        "Normal"
      end
      horse_attributes.update(track_record:, title:)
    end
  end
end

