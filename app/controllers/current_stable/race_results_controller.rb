module CurrentStable
  class RaceResultsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: %i[list summary]

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

      @query = @query.ransack(params[:q])
      @query.sorts = ["race_date desc", "race_number asc"] if @query.sorts.blank?

      @pagy, @results = pagy(@query.result)
    end
  end
end

