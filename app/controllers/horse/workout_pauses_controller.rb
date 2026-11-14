module Horse
  class WorkoutPausesController < AuthenticatedController
    def create
      horse = Horses::Horse.managed_by(Current.stable).find(params[:id])
      authorize horse, :update_race_options?, policy_class: CurrentStable::RacehorsePolicy

      result = Horses::Racing::WorkoutPauser.new.pause_workouts(horse:, date: pause_params[:rest_date_for_workouts])
      if result.saved?
        flash[:success] = t(".success", name: horse.name)
      else
        flash[:error] = t(".failure", name: horse.name)
      end
      redirect_to horse_path(horse)
    end

    private

    def pause_params
      params.expect(racing_race_option: :rest_date_for_workouts)
    end
  end
end

