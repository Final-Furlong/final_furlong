module Horse
  class JumpTrialsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_jump_trials?, policy_class: CurrentStable::HorsePolicy

      query = Horses::JumpTrialPolicy::Scope.new(Current.user, @horse.jump_trials).resolve.includes(:jockey, :racetrack).order(date: :desc)

      @pagy, @trials = pagy(:offset, query)

      render "horse/events/jump_trials"
    end

    def new
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :run_jump_trial?, policy_class: CurrentStable::RacehorsePolicy
      @trial = @horse.jump_trials.build
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :run_jump_trial?, policy_class: CurrentStable::RacehorsePolicy
      @trial = @horse.jump_trials.build

      result = Workouts::JumpTrialCreator.new.run_trial(horse: @horse)
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        flash[:error] = t(".failure")
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            @trial = result.trial
            render turbo_stream: turbo_stream.replace("jump-trial-form", partial: "horse/jump_trials/form", locals: { trial: @trial, horse: @horse })
          end
        end
      end
    end
  end
end

