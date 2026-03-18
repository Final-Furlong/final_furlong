module CurrentStable
  class TrainingSummariesController < ::AuthenticatedController
    def show
      authorize %i[current_stable training_summary]

      @query = policy_scope(Horses::Horse.racehorse, policy_scope_class: CurrentStable::HorsePolicy::Scope)
      if params.dig(:q, :min_energy).present? && params.dig(:q, :max_energy).present?
        params[:q][:energy_in] = [params.dig(:q, :max_energy), params.dig(:q, :min_energy)]
      end
      if params.dig(:q, :min_fitness).present? && params.dig(:q, :max_fitness).present?
        params[:q][:fitness_in] = [params.dig(:q, :max_fitness), params.dig(:q, :min_fitness)]
      end
      if params.dig(:q, :age_in).to_a.include?("4+")
        params[:q][:age_in].push(5, 6, 7, 8, 9, 10)
      end
      if params.dig(:q, :gender_in) == "male"
        params[:q][:gender_in] = Horses::Gender::MALE_GENDERS
      elsif params.dig(:q, :gender_in) == "female"
        params[:q][:gender_in] = Horses::Gender::FEMALE_GENDERS
      end
      if params.dig(:q, :race_entry) == "false"
        params[:q][:no_race_entry] = true
      end

      @query = @query.includes(:race_qualification, :race_metadata).ransack(params[:q])
      @query.sorts = "name asc" if @query.sorts.blank?

      @pagy, @horses = pagy(@query.result)
    end
  end
end

