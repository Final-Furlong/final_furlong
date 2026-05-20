module Horse
  class WorkoutsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_workouts?, policy_class: CurrentStable::HorsePolicy

      query = Horses::WorkoutPolicy::Scope.new(Current.user, @horse.workouts).resolve.includes(:jockey, :racetrack).order(date: :desc)

      @pagy, @workouts = pagy(:countless, query)

      render "horse/events/workouts"
    end

    def new
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :create_workout?, policy_class: CurrentStable::HorsePolicy
      @schedule = @horse.training_schedule
      @workout = @horse.workouts.build
      @workout.store_initial_options(@schedule)
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :create_workout?, policy_class: CurrentStable::HorsePolicy
      @workout = @horse.workouts.build
      jockey_id = workout_params.delete(:jockey)
      jockey = Racing::Jockey.find(jockey_id) if jockey_id.present?
      racetrack = @horse.race_metadata.racetrack
      surface_name = workout_params.delete(:surface)
      surface = racetrack.surfaces.find_by(surface: surface_name) if surface_name.present?

      result = Workouts::WorkoutCreator.new.create_workout(horse: @horse, jockey:, surface:, params: formatted_workout_params)
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        flash[:error] = t(".failure")
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            @workout = result.workout
            render turbo_stream: turbo_stream.replace("workout-form", partial: "horse/workouts/form", locals: { workout: @workout, horse: @horse })
          end
        end
      end
    end

    private

    def formatted_workout_params
      formatted_params = workout_params.dup
      activities = formatted_params.delete(:activities_attributes)
      formatted_params[:activities_attributes] = [
        { activity: activities["0"]["activity"], distance: activities["0"]["distance"] },
        { activity: activities["1"]["activity"], distance: activities["1"]["distance"] },
        { activity: activities["2"]["activity"], distance: activities["2"]["distance"] }
      ]
      formatted_params
    end

    def workout_params
      params.expect(workouts_workout: [:jockey, :effort, :surface, :blinkers, :wraps, :shadow_roll, :figure_8, :no_whip,
        activities_attributes: [[:activity, :distance]]])
    end
  end
end

