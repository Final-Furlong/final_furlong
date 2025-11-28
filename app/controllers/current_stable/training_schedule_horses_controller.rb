module CurrentStable
  class TrainingScheduleHorsesController < ::AuthenticatedController
    before_action :set_schedule
    before_action :set_schedule_horse, only: :create

    skip_after_action :verify_pundit_authorization, only: :index

    attr_reader :schedule, :schedule_horse, :horses, :daily_activities, :horse

    helper_method :schedule, :schedule_horse, :horses, :daily_activities, :horse

    def index
      authorize schedule, :view_horses?
      type = params[:type].to_s.inquiry
      if type.workouts?
        query = policy_scope(Horses::Horse.racehorse.joins(:training_schedule).where(training_schedules: { id: schedule }),
          policy_scope_class: Racing::TrainingScheduleHorsePolicy::Scope)
        query = query.includes(:race_metadata, :race_options, :current_boarding).order(name: :asc)
      else
        horses_query = Horses::Horse.racehorse.left_joins(:training_schedule).where(training_schedules: { id: [schedule, nil] })
        query = policy_scope(horses_query, policy_scope_class: CurrentStable::HorsePolicy::Scope)
      end
      query = query.order(training_schedules: { id: :asc }, name: :asc)

      @pagy, @horses = pagy(:offset, query)
      page = type.workouts? ? "workouts" : "index"
      render "current_stable/training_schedule_horses/#{page}"
    end

    def create
      authorize schedule

      schedule_horse.assign_attributes(schedule_params)
      if authorize(schedule_horse, :create?) && schedule_horse.save!
        flash[:notice] = t(".success", name: schedule_horse.horse.name, schedule: schedule.name)
        redirect_to stable_training_schedules_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      authorize schedule

      @horse = Current.stable.horses.find(params[:id])
      training_schedule_horse = Racing::TrainingScheduleHorse.find_by!(training_schedule: schedule, horse:)
      if training_schedule_horse.destroy!
        delete_message = t("current_stable.training_schedules.horse.deleted", name: horse.name)
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = delete_message }
          format.html { redirect_to stable_training_schedules_path, notice: delete_message }
        end
      end
    end

    private

    def set_schedule
      @schedule = Current.stable.training_schedules.find(params[:training_schedule_id])
      @daily_activities = schedule.daily_activities
      @schedule
    end

    def set_schedule_horse
      @schedule_horse = Racing::TrainingScheduleHorse.new(training_schedule: schedule)
    end

    def set_stable_horses
      @horses = Horses::Horse.racehorse.where.missing(:training_schedule).managed_by(Current.stable).order(name: :asc)
    end

    def schedule_params
      params.expect(racing_training_schedule_horse: [:training_schedule_id, :horse_id])
    end

    def unauthorized_path
      stable_training_schedules_path
    end
  end
end

