module Dashboard::Racing
  class Entry
    attr_reader :race, :params, :user, :query, :pagy, :count, :qualifications

    def initialize(race:, params:, user:)
      @race = race
      status = params[:q].delete(:racehorse_status)
      @params = params
      @user = user
      @query = ::Racing::RaceQualificationQuery.new(race: @race, status:).qualified(apply_settings: false)
      @query = CurrentStable::HorsePolicy::Scope.new(Current.user, @query).resolve
      params = apply_settings_to_params
      if params.dig(:q, :age_in).to_a.include?("4+")
        params[:q][:age_in].push(5, 6, 7, 8, 9, 10)
      end
      @query = @query.joins(:race_qualification).includes(:race_options, manager: { racetrack: :location }, racehorse_metadata: { racetrack: :location })
      fetch_counts(@query)
      @query = @query.ransack(params[:q])
      @query.sorts = ["name asc"] if @query.sorts.empty?
      @query.sorts.insert 0, Ransack::Nodes::Sort.extract(@query.context, "race_options_racehorse_type desc")
    end

    private

    def fetch_counts(query)
      @count = query.ransack(params[:q]).result.count
      @qualifications = {}
      type_index = Config::Racing.all_types.find_index(@race.race_type)
      Config::Racing.all_types.each_with_index do |type, index|
        this_query = query.dup
        if @race.race_type != "claiming"
          next if type == "claiming" || index > type_index
          this_query = if type == "stakes"
            this_query.merge(Racing::RaceQualification.stakes_level)
          elsif type == "allowance"
            this_query.merge(Racing::RaceQualification.allowance_level)
          else
            this_query.merge(Racing::RaceQualification.qualified_for(type))
          end
        else
          this_query = this_query.where(race_qualifications: { claiming_qualified: true })
          this_query = if type == "stakes"
            this_query.merge(Racing::RaceQualification.stakes_level)
          elsif type == "allowance"
            this_query.merge(Racing::RaceQualification.allowance_level)
          else
            this_query.where(race_qualifications: { "#{type}_qualified": true })
          end
        end
        count = this_query.ransack(params[:q]).result.count
        next if count.zero?

        @qualifications[type] = "#{I18n.t("racing.race.#{type}")} (#{count})"
      end
    end

    def apply_settings_to_params
      params[:q] ||= {}
      if (energy = game_settings[:minimum_energy])
        params[:q][:min_energy] ||= energy
      end
      if (min_days = game_settings[:minimum_days_since_last_race])
        params[:q][:min_days_since_last_race] ||= min_days
      end
      if (min_days = game_settings[:minimum_days_since_last_injury])
        params[:q][:min_days_since_last_injury] ||= min_days
      end
      if (min_days = game_settings[:minimum_rest_days_since_last_race])
        params[:q][:min_rest_days_since_last_injury] ||= min_days
      end
      if (min_workouts = game_settings[:minimum_workouts_since_last_race])
        params[:q][:min_workouts_since_last_race] ||= min_workouts
      end
      params
    end

    def game_settings
      return {} unless user.setting&.racing
      {
        minimum_energy: user.setting.racing.min_energy_for_race_entry,
        minimum_days_since_last_race: user.setting.racing.min_days_delay_from_last_race,
        minimum_days_since_last_injury: user.setting.racing.min_days_delay_from_last_injury,
        minimum_rest_days_since_last_race: user.setting.racing.min_days_rest_between_races,
        minimum_workouts_since_last_race: user.setting.racing.min_workouts_between_races
      }
    end
  end
end

