module Racing
  class BreedersCupEntrySelector
    attr_reader :race

    def select_horses(race:)
      @race = race
      Racing::BreedersCupPotentialEntry.where(race:).delete_all
      result = Result.new
      rank = 1
      horse_ids = []
      key = "#{race.name.delete("'").tr(" ", "_").gsub("&", "and").downcase}_qualification"
      class_info = Config::Racing.qualification_classes.find { |info| info[:key] == key }
      klass = class_info[:class].constantize
      while rank <= 50
        horse_ids, rank, horses_added = process_qualifiers(klass:, horse_ids:, rank:)
        break if horses_added.zero?
      end
      result.horses += horse_ids.count
      rank = 1
      horse_ids = []
      while rank <= 20
        horse_ids, rank, horses_added = process_qualifiers(klass:, horse_ids:, rank:, game_owned: true)
        break if horses_added.zero?
      end
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

    def process_qualifiers(klass:, horse_ids:, rank:, game_owned: false)
      horses = 0
      max_horses = game_owned ? 20 : 50
      query = klass.nominated.joins(:horse).includes(:horse).where.not(horse_id: horse_ids)
      query = game_owned ? query.merge(Horses::Horse.game_owned) : query.merge(Horses::Horse.not_game_owned)
      qualifiers = query.ordered.limit(max_horses)
      qualifiers.each do |qualifier|
        break if rank > max_horses

        horse = qualifier.horse
        tied_query = klass.nominated.identically_ranked(qualifier).joins(:horse).includes(horse: :manager)
        tied_query = game_owned ? tied_query.merge(Horses::Horse.game_owned) : tied_query.merge(Horses::Horse.not_game_owned)
        tied = tied_query.count
        if tied > 1
          tied_horses = tied_query.random_order
          tied_horses.each do |tied_qualifier|
            break if rank > max_horses

            if create_entry(horse: tied_qualifier.horse, qualifier: tied_qualifier, rank:)
              horse_ids << tied_qualifier.horse_id
              rank += 1
              horses += 1
            end
          end
          return [horse_ids, rank, horses]
        else
          create_entry(horse:, qualifier:, rank:)
          horse_ids << qualifier.horse_id
          rank += 1
          horses += 1
        end
      end
      [horse_ids, rank, horses]
    end

    def create_entry(horse:, qualifier:, rank:)
      entry = Racing::BreedersCupPotentialEntry.find_or_initialize_by(horse:, race:)
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

