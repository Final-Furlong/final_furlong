require "ransack/helpers/form_helper"

module Racing
  module HorseQualificationSearch
    class Component < ApplicationComponent
      include Ransack::Helpers::FormHelper

      attr_reader :race, :age, :surface_type, :female, :male, :statuses, :params, :path_name

      def initialize(race:, params: {}, path_name: nil)
        @race = race
        @age = race.age
        @surface_type = race.race_surface_type.inquiry
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
        if Config::Racing.non_qualified_types.include?(race_type)
          list << "allowance" unless list.include?("allowance")
          list << "stakes" unless list.include?("stakes")
        end
        list
      end

      def render?
        statuses.any?
      end

      def status_count(status)
        query = Racing::RaceQualificationQuery.new(status:, race:).qualified
        query.count
      end

      def min_age
        race.min_age
      end

      def max_age
        race.max_age
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

