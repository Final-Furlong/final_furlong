module CurrentStable
  class TrainingScheduleHorsesController < ::AuthenticatedController
    before_action :set_schedule
    before_action :set_schedule_horse, only: %i[new create]
    before_action :set_stable_horses, only: :new

    attr_reader :schedule, :schedule_horse, :horses, :daily_activities, :horse

    helper_method :schedule, :schedule_horse, :horses, :daily_activities, :horse

    # @route GET /stable/training_schedules/:training_schedule_id/horses (stable_training_schedule_horses)
    def index
      authorize schedule, :view_horses?
      @horses = Horses::HorsesQuery.with_training_schedule(schedule).owned_by(current_stable)
    end

    # @route GET /stable/training_schedules/:training_schedule_id/horses/new (new_stable_training_schedule_horse)
    def new
      authorize schedule
    end

    # @route POST /stable/training_schedules/:training_schedule_id/horses (stable_training_schedule_horses)
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

    # @route DELETE /stable/training_schedules/:training_schedule_id/horses/:id (stable_training_schedule_horse)
    def destroy
      authorize schedule

      @horse = current_stable.horses.find(params[:id])
      training_schedule_horse = Racing::TrainingScheduleHorse.find_by!(training_schedule: schedule, horse: horse)
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
      @schedule = current_stable.training_schedules.find(params[:training_schedule_id])
      weekday = Time.zone.today.strftime("%A")
      @daily_activities = schedule.send("#{weekday.downcase}_activities")
      @schedule
    end

    def set_schedule_horse
      @schedule_horse = Racing::TrainingScheduleHorse.new(training_schedule: schedule)
    end

    def set_stable_horses
      @horses = Horses::HorsesQuery.without_training_schedules.owned_by(current_stable)
    end

    def schedule_params
      params.require(:racing_training_schedule_horse).permit(:training_schedule_id, :horse_id)
    end

    def unauthorized_path
      stable_training_schedules_path
    end
  end
end

