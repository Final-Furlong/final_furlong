module Racing
  class EntryOptionsController < AuthenticatedController
    def new
      race = Racing::RaceSchedule.find(params[:race_id])
      @horse = Horses::Horse.racehorse.find(params[:horse])
      @entry = Racing::RaceEntry.new(date: race.date, race:, horse: @horse)
      @entry.store_initial_options
      authorize @entry
    end

    def edit
      race = Racing::RaceSchedule.find(params[:race_id])
      @entry = race.entries.find(params[:id])
      @horse = @entry.horse
      authorize @entry
    end

    def create
      race = Racing::RaceSchedule.find(params[:race_id])
      @horse = Horses::Horse.racehorse.find(params.dig(:racing_race_entry, :horse_id))
      @entry = Racing::RaceEntry.new(date: race.date, race:, horse: @horse)
      @entry.store_initial_options
      authorize @entry

      result = Racing::EntryCreator.new.create_entry(**entry_creator_params(race))
      if result.created?
        flash[:success] = t(".success", name: @horse.name)
        redirect_to new_racing_race_entry_path(race)
      else
        flash[:error] = t(".failure", name: @horse.name)
        respond_to do |format|
          format.html { redirect_to new_racing_race_entry_path(race) }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("race-entry-form", partial: "racing/entry_options/form", locals: { entry: result.entry, horse: @horse, error: result.error, url: racing_race_entry_options_path(race) })
          end
        end
      end
    end

    def update
      race = Racing::RaceSchedule.find(params[:race_id])
      @entry = race.entries.find(params[:id])
      @horse = @entry.horse
      authorize @entry

      result = Racing::EntryUpdater.new.update_entry(**entry_updater_params(@entry))
      if result.updated?
        flash[:success] = t(".success", name: @horse.name)
        redirect_to new_racing_race_entry_path(race)
      else
        flash[:error] = t(".failure", name: @horse.name)
        respond_to do |format|
          format.html { redirect_to new_racing_race_entry_path(race) }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("race-entry-form", partial: "racing/entry_options/form", locals: { entry: result.entry, horse: @horse, error: result.error, url: racing_race_entry_option_path(race, result.entry) })
          end
        end
      end
    end

    private

    def entry_updater_params(entry)
      {
        entry:, stable: Current.stable, racing_style: entry_params[:racing_style],
        first_jockey: entry_params[:first_jockey], second_jockey: entry_params[:second_jockey],
        third_jockey: entry_params[:third_jockey], shipping_mode: entry_params[:shipping_mode],
        blinkers: entry_params[:blinkers], shadow_roll: entry_params[:shadow_roll],
        wraps: entry_params[:wraps], no_whip: entry_params[:no_whip], figure_8: entry_params[:figure_8]
      }
    end

    def entry_creator_params(race)
      {
        race:, horse: @horse, stable: Current.stable, racing_style: entry_params[:racing_style],
        first_jockey: entry_params[:first_jockey], second_jockey: entry_params[:second_jockey],
        third_jockey: entry_params[:third_jockey], shipping_mode: entry_params[:shipping_mode],
        blinkers: entry_params[:blinkers], shadow_roll: entry_params[:shadow_roll],
        wraps: entry_params[:wraps], no_whip: entry_params[:no_whip], figure_8: entry_params[:figure_8]
      }
    end

    def entry_params
      params.expect(racing_race_entry: [:racing_style, :first_jockey, :second_jockey, :third_jockey, :shipping_mode, :blinkers, :shadow_roll, :wraps, :no_whip, :figure_8])
    end
  end
end

