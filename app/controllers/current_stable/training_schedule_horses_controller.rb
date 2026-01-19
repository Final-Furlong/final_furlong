module CurrentStable
  class TrainingScheduleHorsesController < ::AuthenticatedController
    before_action :set_schedule
    before_action :set_schedule_horse, only: %i[new create]
    before_action :set_stable_horses, only: :new

    skip_after_action :verify_pundit_authorization, only: :index

    attr_reader :schedule, :schedule_horse, :horses, :daily_activities, :horse

    helper_method :schedule, :schedule_horse, :horses, :daily_activities, :horse

    def index
      authorize schedule, :view_horses?
      @horses = Horses::Horse.joins(:training_schedule).where(training_schedules: { id: schedule }, owner: Current.stable)
    end

    def new
      authorize schedule
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
      weekday = Time.zone.today.strftime("%A")
      @daily_activities = schedule.send(:"#{weekday.downcase}_activities")
      @schedule
    end

    def set_schedule_horse
      @schedule_horse = Racing::TrainingScheduleHorse.new(training_schedule: schedule)
    end

    def set_stable_horses
      @horses = Horses::Horse.where.missing(:training_schedule).where(owner: Current.stable)
    end

    def schedule_params
      params.expect(racing_training_schedule_horse: [:training_schedule_id, :horse_id])
    end

    def unauthorized_path
      stable_training_schedules_path
    end
  end
end

