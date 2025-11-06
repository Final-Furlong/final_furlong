module Horses
  class UpdateHorseAttributesService # rubocop:disable Metrics/ClassLength
    def call(horse:)
      update_horse(horse)
    end

    private

    def update_horse(horse)
      horse_attributes = horse.horse_attributes || horse.build_horse_attributes
      record = horse.lifetime_race_record
      track_record = if record.stakes_wins > 1 && record.stakes_places > 1
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
      if record.earnings >= 2_000_000
        track_record += ", Multi-Millionaire"
      elsif record.earnings >= 1_000_000
        track_record += ", Millionaire"
      end
      horse_attributes.update(track_record:)
    end
  end
end

