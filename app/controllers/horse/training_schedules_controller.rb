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

      schedule_horse = horse.training_schedules_horse || horse.build_training_schedules_horse
      schedule_horse.assign_attributes(schedule_params)
      if schedule_horse.save!
        flash[:notice] = t(".success", name: @horse.name, schedule: schedule.name)
        redirect_to horse_path(@horse)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @horse = Current.stable.racehorses.includes(:training_schedules_horse).find(params[:id])
      training_schedule_horse = @horse.training_schedules_horse
      authorize training_schedule_horse.training_schedule

      if training_schedule_horse&.destroy!
        delete_message = t("current_stable.training_schedules.horse.deleted", name: @horse.name)
        redirect_to horse_path(@horse), notice: delete_message
      end
    end

    private

    def options_params
      params.expect(horses_stallion_option: [:stud_fee, :outside_mares_allowed, :outside_mares_per_stable, :approval_required, :breed_to_game_mares])
    end
  end
end

