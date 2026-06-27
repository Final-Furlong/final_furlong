module CurrentStable
  class RecentFoalsController < AuthenticatedController
    def index
      @query = policy_scope(Horses::Horse, policy_scope_class: CurrentStable::HorsePolicy::Scope)
      @date = Date.parse(params[:date])
      @query = if @date
        if params[:this_date]
          @query.where(date_of_birth: @date)
        else
          @query.where("horses.date_of_birth BETWEEN ? AND ?", @date, Date.current)
        end
      else
        @query.where(date_of_birth: ..Date.current)
      end
      @query = @query.includes(:breeder, :appearance, sire: :foal_record, dam: [:foal_record, :sire])
      @query = @query.ransack(params[:q])
      update_user_activity

      @count = @query.result.count

      @pagy, @foals = pagy(:countless, @query.result)
    end

    private

    def update_user_activity
      activity = Current.user.activity || Current.user.build_activity
      activities = activity.activities
      date = params[:this_date] ? params[:date] : Date.current
      return if activities.key?(:view_recent_foals) && activities[:view_recent_foals].to_date >= date

      activities[:view_recent_foals] = date.to_date.beginning_of_day
      activity.update(activities:)
    end
  end
end

