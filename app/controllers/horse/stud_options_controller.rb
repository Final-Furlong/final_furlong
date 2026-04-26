module Horse
  class StudOptionsController < ApplicationController
    def new
      horse = Horses::Horse.find(params[:id])
      authorize horse, :update_stud_options?, policy_class: CurrentStable::StallionPolicy

      @options = horse.stud_options || horse.build_stud_options
    end

    def edit
      horse = Horses::Horse.find(params[:id])
      authorize horse, :update_stud_options?, policy_class: CurrentStable::StallionPolicy

      @options = horse.stud_options
    end

    def create
      horse = Horses::Horse.find(params[:id])
      authorize horse, :update_stud_options?, policy_class: CurrentStable::StallionPolicy

      @options = horse.stud_options || horse.build_stud_options
      result = Horses::Stud::StudOptionsUpdater.new.update_options(options: @options, params: options_params)
      if result.saved?
        flash[:success] = t(".success")
        redirect_to horse_path(horse)
      else
        flash[:error] = t(".failure")
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("stud-options-form", partial: "horse/stud_options/form", locals: { options: result.options, horse: })
          end
        end
      end
    end

    def update
      horse = Horses::Horse.find(params[:id])
      authorize horse, :update_stud_options?, policy_class: CurrentStable::StallionPolicy

      @options = horse.stud_options
      result = Horses::Stud::StudOptionsUpdater.new.update_options(options: @options, params: options_params)
      if result.saved?
        flash[:success] = t(".success")
        redirect_to horse_path(horse)
      else
        flash[:error] = t(".failure")
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("stud-options-form", partial: "horse/stud_options/form", locals: { options: result.options, horse: })
          end
        end
      end
    end

    private

    def options_params
      params.expect(horses_stallion_option: [:stud_fee, :outside_mares_allowed, :outside_mares_per_stable, :approval_required, :breed_to_game_mares])
    end
  end
end

