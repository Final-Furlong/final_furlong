require "ransack/helpers/form_helper"

module Racing
  module HorseQualificationSearch
    class Component < ApplicationComponent
      include Ransack::Helpers::FormHelper

      attr_reader :race, :age, :surface_type, :female, :male, :statuses, :params, :path_name

      def initialize(race:, params: {}, path_name: nil)
        @race = race
        @age = race.age
        @surface_type = race.race_surface_type
        @female = race.female_only
        @male = race.male_only
        @statuses = load_statuses(race.race_type)
        @params = params
        @path_name = path_name
        super()
      end

      private

      def load_statuses(race_type)
        list = Config::Racing.all_types.slice(0, Config::Racing.all_types.find_index(race_type) + 1)
        list.delete("claiming") unless race_type == "claiming"
        list.delete("starter_allowance") unless race_type == "starter_allowance"
        list
      end

      def render?
        statuses.any?
      end

      def status_count(status)
        query = Horses::Horse.racehorse.managed_by(Current.stable).min_age(min_age).max_age(max_age)
        query = CurrentStable::RacehorsePolicy::Scope.new(Current.user, query).resolve
        query = query.female if female
        query = query.not_female if male
        query = query.joins(:race_metadata)
        query = query.joins(:race_qualification).merge(Racing::RaceQualification.send(:qualified_for, status))
        query = query.joins(:race_options).merge(Racing::RaceOption.send(surface_type.to_sym)).merge(Racing::RaceOption.distance_matching(race.distance))
          .merge(Racing::RaceOption.send(race.surface_name.to_sym))
        query.count
      end

      def min_age
        race.min_age
      end

      def max_age
        if age.chars.include?("+")
          10
        else
          min_age
        end
      end

      def url_with_params(status)
        params[:q] = { racehorse_status: status, race: }

        send(path_name.to_sym, q: params[:q])
      end

      def localised_status(status)
        I18n.t("racing.race.#{status}")
      end
    end
  end
end

