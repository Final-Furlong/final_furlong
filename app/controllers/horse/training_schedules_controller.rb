module Horse
  class TrainingSchedulesController < ApplicationController
    def show
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_training_schedule?, policy_class: CurrentStable::RacehorsePolicy
      @schedule = @horse.training_schedule
    end

    def edit
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :set_training_schedule?, policy_class: CurrentStable::RacehorsePolicy

      @schedules = Racing::TrainingSchedule.valid_for_horse(@horse)
    end

    def update
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :set_training_schedule?, policy_class: CurrentStable::RacehorsePolicy

      schedule_horse = @horse.training_schedules_horse || @horse.build_training_schedules_horse
      schedule_horse.assign_attributes(schedule_params)
      if schedule_horse.save
        schedule = schedule_horse.training_schedule.name
        redirect_to horse_path(@horse), success: t(".success", name: @horse.name, schedule:)
      else
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("training-schedule-form", partial: "horse/training_schedules/form", locals: { horse: @horse, schedule: schedule_horse })
          end
        end
      end
    end

    def destroy
      @horse = Current.stable.racehorses.includes(:training_schedules_horse).find(params[:id])
      training_schedule_horse = @horse.training_schedules_horse
      authorize training_schedule_horse.training_schedule

      if training_schedule_horse&.destroy!
        delete_message = t("current_stable.training_schedules.horse.deleted", name: @horse.name)
        redirect_to horse_path(@horse), success: delete_message
      end
    end

    private

    def schedule_params
      params.expect(racing_training_schedule_horse: [:training_schedule_id])
    end
  end
end

