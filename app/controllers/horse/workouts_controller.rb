module Horse
  class WorkoutsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_workouts?, policy_class: CurrentStable::HorsePolicy

      query = Horses::WorkoutPolicy::Scope.new(Current.user, @horse.workouts).resolve.order(date: :desc)

      @pagy, @workouts = pagy(:offset, query)

      render "horse/events/workouts"
    end
  end
end

