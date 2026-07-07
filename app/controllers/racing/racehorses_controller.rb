module Racing
  class RacehorsesController < AuthenticatedController
    def index
      raise ActiveRecord::RecordNotFound if params.dig(:q, :race).blank?

      @race = Racing::RaceSchedule.includes(track_surface: :racetrack).find(params.dig(:q, :race))
      status = params[:q].delete(:status)
      @query = RaceQualificationQuery.new(race: @race, status:).qualified(apply_settings: false)
      @query = policy_scope(@query, policy_scope_class: CurrentStable::HorsePolicy::Scope)
      params = apply_settings_to_params
      if params.dig(:q, :age_in).to_a.include?("4+")
        params[:q][:age_in].push(5, 6, 7, 8, 9, 10)
      end
      @query = @query.joins(:race_qualification).includes(:race_options, manager: { racetrack: :location }, racehorse_metadata: { racetrack: :location })
      fetch_counts(@query)
      @query = @query.ransack(params[:q])
      @query.sorts = ["name asc"] if @query.sorts.empty?
      @query.sorts.insert 0, Ransack::Nodes::Sort.extract(@query.context, "race_options_racehorse_type desc")

      @pagy, @horses = pagy(:countless, @query.result)
    end

    private

    def fetch_counts(query)
      @count = query.ransack(params[:q]).result.count
      @qualifications = {}
      type_index = Config::Racing.all_types.find_index(@race.race_type)
      Config::Racing.all_types.each_with_index do |type, index|
        if @race.race_type != "claiming"
          next if type == "claiming" || index > type_index
          query = query.merge(Racing::RaceQualification.qualified_for(type))
        else
          query = query.where(race_qualifications: { claiming_qualified: true })
          query = if type == "stakes"
            query.where(race_qualifications: { stakes_placed: true })
          elsif type == "allowance"
            query.where(race_qualifications: { nw3_allowance_qualified: false })
          else
            query.where(race_qualifications: { claiming_qualified: true, "#{type}_qualified": true })
          end
        end
        count = query.ransack(params[:q]).result.count
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
      return {} unless Current.user.setting&.racing
      {
        minimum_energy: Current.user.setting.racing.min_energy_for_race_entry,
        minimum_days_since_last_race: Current.user.setting.racing.min_days_delay_from_last_race,
        minimum_days_since_last_injury: Current.user.setting.racing.min_days_delay_from_last_injury,
        minimum_rest_days_since_last_race: Current.user.setting.racing.min_days_rest_between_races,
        minimum_workouts_since_last_race: Current.user.setting.racing.min_workouts_between_races
      }
    end
  end
end

