module Horse
  class RaceOptionsController < ApplicationController
    def edit
      horse = Horses::Horse.find(params[:id])
      authorize horse, :update_race_options?, policy_class: CurrentStable::RacehorsePolicy

      @options = horse.race_options
    end

    def update
      horse = Horses::Horse.find(params[:id])
      authorize horse, :update_race_options?, policy_class: CurrentStable::RacehorsePolicy

      @options = horse.race_options
      result = Horses::Racing::RaceOptionsUpdater.new.update_options(options: @options, params: options_params)
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(horse)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("race-options-form", partial: "horse/race_options/form", locals: { options: result.options, horse: })
          end
        end
      end
    end

    private

    def options_params
      params.expect(racing_race_option: [:racing_style, :first_jockey, :second_jockey, :third_jockey, :minimum_distance, :maximum_distance,
        :blinkers, :shadow_roll, :wraps, :no_whip, :figure_8, :note_for_next_race, :racing_style, :runs_on_dirt, :runs_on_turf,
        :trains_on_dirt, :trains_on_turf])
    end
  end
end

