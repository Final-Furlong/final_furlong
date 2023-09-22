module CurrentStable
  class TrainingSchedulesController < ::AuthenticatedController
    before_action :set_schedule, except: %i[index new create]
    before_action :new_schedule, only: %i[new create]

    attr_reader :schedule

    helper_method :schedule

    # @route GET /stable/training_schedules (stable_training_schedules)
    def index
      @schedules = authorized_scope(Racing::TrainingSchedule.all)
    end

    # @route GET /stable/training_schedules/:id (stable_training_schedule)
    def show
    end

    # @route GET /stable/training_schedules/new (new_stable_training_schedule)
    def new
      authorize schedule
    end

    # @route GET /stable/training_schedules/:id/edit (edit_stable_training_schedule)
    def edit
      authorize schedule
    end

    # @route POST /stable/training_schedules (stable_training_schedules)
    def create
      authorize schedule

      if schedule.update(schedule_params)
        redirect_to stable_training_schedules_path, notice: t(".success", name: @schedule.name)
      else
        flash[:alert] = schedule.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    # @route PATCH /stable/training_schedules/:id (stable_training_schedule)
    # @route PUT /stable/training_schedules/:id (stable_training_schedule)
    def update
      authorize schedule

      if schedule.update(schedule_params)
        redirect_to stable_training_schedules_path, notice: t(".success", name: @schedule.name)
      else
        flash[:alert] = schedule.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    # @route DELETE /stable/training_schedules/:id (stable_training_schedule)
    def destroy
      authorize schedule

      schedule.destroy!

      delete_message = t("current_stable.training_schedules.deleted", name: schedule.name)
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = delete_message }
        format.html { redirect_to stable_training_schedules_path, notice: delete_message }
      end
    end

    private

    def set_schedule
      @schedule = current_stable.training_schedules.find(params[:id])
    end

    def new_schedule
      @schedule = current_stable.training_schedules.build
    end

    def schedule_params
      params.require(:training_schedule).permit(:description, :name,
        sunday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3],
        monday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3],
        tuesday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3],
        wednesday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3],
        thursday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3],
        friday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3],
        saturday_activities_attributes: [:activity1, :distance1, :activity2, :distance2, :activity3, :distance3]).merge(stable: current_stable)
    end
  end
end

