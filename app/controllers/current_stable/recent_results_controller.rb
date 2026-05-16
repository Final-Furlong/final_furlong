module CurrentStable
  class RecentResultsController < AuthenticatedController
    def show
      @query = policy_scope(Racing::RaceResultHorse, policy_scope_class: CurrentStable::RaceResultHorsePolicy::Scope)
      @date = Date.parse(params[:date])
      @query = @query.includes(horse: :sire, race: :track_surface).where(race: { date: @date }).order(race: { number: :asc })
      authorize @query.first.race

      update_user_activity
      @results = @query.to_a
    end

    private

    def update_user_activity
      activity = Current.user.activity || Current.user.build_activity
      activities = activity.activities
      return if activities.key?(:view_race_results) && activities[:view_race_results].to_date >= params[:date]

      activities[:view_race_results] = params[:date].to_date.beginning_of_day
      activity.update(activities:)
    end
  end
end

