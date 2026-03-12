module Horse
  class InjuriesController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_injuries?, policy_class: CurrentStable::HorsePolicy

      query = Horses::InjuryPolicy::Scope.new(Current.user, @horse.historical_injuries).resolve.order(date: :desc)

      @pagy, @injuries = pagy(:offset, query)

      render "horse/events/injuries"
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

      result = Workouts::WorkoutCreator.new.create_workout(horse: @horse, jockey:, surface:, params: workout_params)
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

    def workout_params
      params.expect(workouts_workout: [:jockey, :effort, :surface, :blinkers, :wraps, :shadow_roll, :figure_8, :no_whip,
        activities_attributes: [[:activity, :distance]]])
    end
  end
end

