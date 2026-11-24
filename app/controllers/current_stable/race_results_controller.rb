module CurrentStable
  class RaceResultsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: %i[list summary grade_results]

    def index
      @query = policy_scope(Racing::StableAnnualRaceRecord)
    end

    def summary
      @query = policy_scope(Racing::StableAnnualRaceRecord.order(year: :desc))
    end

    def list
      @query = policy_scope(Racing::RaceResultHorse, policy_scope_class: CurrentStable::RaceResultHorsePolicy::Scope).includes(:race)
      date = params[:date].presence
      @query = @query.where(date:) if date
      @query = @query.includes(:horse, race: [:track_surface])
      @query = @query.ransack(params[:q])
      @query.sorts = ["race_date desc", "race_number asc"] if @query.sorts.blank?

      @pagy, @results = pagy(@query.result)
    end

    def grade_results
      raise ActiveRecord::RecordNotFound unless params.key?(:grade)

      grade = params[:grade].tr("_", " ").titleize
      query = Racing::RaceResult.by_type("stakes").where(grade:).joins(:horses).merge(Racing::RaceResultHorse.where(stable: Current.stable).by_max_finish(3)).group(:name).order(name: :asc).select(:name)
      @pagy, @results = pagy(query)
    end
  end
end

