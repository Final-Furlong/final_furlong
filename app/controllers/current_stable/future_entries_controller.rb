module CurrentStable
  class FutureEntriesController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :show

    def show
      @query = policy_scope(Racing::FutureRaceEntry.current_or_future.where(stable: Current.stable)).includes(:race)
      @query = @query.includes(:horse, :stable, race: { track_surface: :racetrack })
      if params[:date]
        @date = Date.parse(params[:date]) if params[:date]
        @query = @query.where(race: { date: @date })
      end
      @query = @query.ransack(params[:q])
      @query.sorts = ["status asc", "race_date asc", "race_number asc", "horse_name asc"] if @query.sorts.blank?

      @pagy, @results = pagy(:countless, @query.result)
      @count = @query.result.count if @pagy.page == 1
    end
  end
end

