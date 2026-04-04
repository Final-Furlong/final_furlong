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
      @query = policy_scope(Racing::RaceResult, policy_scope_class: CurrentStable::RaceResultPolicy::Scope).includes(track_surface: :racetrack)
      date = params[:date].presence
      @query = @query.where(date:) if date

      @query = @query.ransack(params[:q])
      @query.sorts = ["date asc", "number asc"] if @query.sorts.blank?

      @pagy, @races = pagy(@query.result)
    end
  end
end

