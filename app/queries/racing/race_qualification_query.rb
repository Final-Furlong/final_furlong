module Racing
  class RaceQualificationQuery
    attr_reader :race, :status, :query

    module Scopes
      def ordered
        order(name: :asc)
      end
    end

    def initialize(race: nil, status: nil)
      @race = race
      @status = status
      @query = Horses::Horse.extending(Scopes)
    end

    def qualified(apply_settings: true)
      @query = query.racehorse.managed_by(Current.stable).joins(:race_metadata).where.missing(:race_entries)
      if apply_settings
        @query = CurrentStable::RacehorsePolicy::Scope.new(Current.user, query).resolve
      end
      @query = query.joins(:race_qualification).merge(Racing::RaceQualification.send(:qualified_for, status)) if status.present?
      if race
        @query = query.min_age(min_age).max_age(max_age)
        @query = query.female if female_only
        @query = query.not_female if male_only
        @query = query.joins(:race_options).merge(Racing::RaceOption.distance_matching(distance))
          .merge(Racing::RaceOption.send(surface_name.to_sym))
        if surface_type.flat?
          query.merge(Racing::RaceOption.send(surface_type.to_sym))
        end
      end
      query
    end

    delegate :with_stable, to: :query

    delegate :ordered, to: :query

    delegate :min_age, :max_age, :female_only, :male_only, :distance,
      :surface_name, :race_surface_type, to: :race

    private

    def surface_type
      race.race_surface_type.inquiry
    end
  end
end

