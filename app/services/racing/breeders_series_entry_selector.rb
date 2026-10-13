module Racing
  class BreedersSeriesEntrySelector
    attr_reader :race

    def select_horses(race:, series:)
      @race = race
      Racing::BreedersSeriesPotentialEntry.where(first_race: race).delete_all
      result = Result.new
      rank = 1
      horse_ids = []
      key = "breeders_series_#{series.delete("'").tr(" ", "_").downcase}_qualification"
      class_info = Config::Racing.qualification_classes.find { |info| info[:key] == key }
      klass = class_info[:class].constantize
      while rank <= 50
        horse_ids, rank, horses_added = process_qualifiers(klass:, horse_ids:, rank:, series:)
        break if horses_added.zero?
      end
      result.horses += horse_ids.count
      result
    end

    class Result
      attr_accessor :created, :error, :horses

      def initialize(created: false, error: nil, horses: 0)
        @created = created
        @error = error
        @horses = horses
      end

      def created?
        @created
      end
    end

    def process_qualifiers(klass:, horse_ids:, rank:, series:)
      horses = 0
      max_horses = 50
      query = klass.joins(:horse).includes(:horse).where.not(horse_id: horse_ids).merge(Horses::Horse.not_game_owned)
      qualifiers = query.ordered.limit(max_horses)
      qualifiers.each do |qualifier|
        break if rank > max_horses

        horse = qualifier.horse
        tied_query = klass.identically_ranked(qualifier).joins(:horse).includes(horse: :manager).merge(Horses::Horse.not_game_owned)
        tied = tied_query.count
        if tied > 1
          tied_horses = tied_query.random_order
          tied_horses.each do |tied_qualifier|
            break if rank > max_horses

            if create_entry(horse: tied_qualifier.horse, qualifier: tied_qualifier, rank:, series:)
              horse_ids << tied_qualifier.horse_id
              rank += 1
              horses += 1
            end
          end
          return [horse_ids, rank, horses]
        else
          create_entry(horse:, qualifier:, rank:, series:)
          horse_ids << qualifier.horse_id
          rank += 1
          horses += 1
        end
      end
      [horse_ids, rank, horses]
    end

    def create_entry(horse:, qualifier:, rank:, series:)
      race_query = Racing::RaceSchedule.joins(:track_surface).where.not(id: race.id).merge(Racing::RaceSchedule.breeders_series)
      race_query = if series.starts_with?("Steeplechase")
        race_query.where(track_surface: { surface: "steeplechase" })
      elsif series.ends_with?("Dirt")
        race_query.where(track_surface: { surface: "dirt" })
      else
        race_query.where(track_surface: { surface: "turf" })
      end
      race_query = if series.starts_with?("2")
        race_query.where(age: "2")
      elsif series.starts_with?("3")
        race_query.where(age: "3")
      else
        race_query.where.not(age: %w[2 3])
      end
      race_query = if series.include?("Filly") || series.include?("Mare")
        race_query.where(female_only: true)
      else
        race_query.where(male_only: true)
      end
      other_races = race_query.order(date: :asc).to_a

      entry = Racing::BreedersSeriesPotentialEntry.find_or_initialize_by(horse:, first_race: race, second_race: other_races[0], third_race: other_races[1])
      entry.stable = horse.manager
      record = "#{I18n.t("horse.race_nominations.index.starts_count", count: qualifier.starts)}, "
      record += "#{I18n.t("horse.race_nominations.index.stakes_wins_count", count: qualifier.stakes_wins)}, "
      record += "#{I18n.t("horse.race_nominations.index.stakes_places_count", count: qualifier.stakes_seconds + qualifier.stakes_thirds)}, "
      record += "#{I18n.t("horse.race_nominations.index.allowance_wins_count", count: qualifier.allowance_wins)}, "
      record += I18n.t("horse.race_nominations.index.points_count", count: qualifier.points)
      entry.record = record
      unless entry.persisted?
        entry.rank = rank
      end
      entry.save!
    end
  end
end

