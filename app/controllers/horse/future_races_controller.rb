module Horse
  class FutureRacesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :schedule_race?, policy_class: CurrentStable::RacehorsePolicy

      entry_ids = Racing::RaceEntry.where(horse: @horse).pluck(:race_id)
      entry_ids += Racing::FutureRaceEntry.where(horse: @horse).pluck(:race_id)
      dates = Racing::RaceSchedule.where(id: entry_ids).select(:date).distinct

      @query = Racing::RaceSchedule.where.not(date: dates.map(&:date)).entries_not_yet_open.for_age(@horse.age)
        .for_race_options(@horse.race_options).for_race_qualification(@horse.race_qualification)
        .includes(track_surface: :racetrack)
        .order(date: :asc).ordered_by_race_type

      @existing_schedules = Racing::RaceSchedule.where(id: entry_ids).pluck(:date)
      @min_days = if Current.user.setting&.racing&.apply_minimums_for_future_races
        Current.user.setting&.racing&.min_days_delay_from_last_race.to_i
      else
        0
      end

      @pagy, @races = pagy(:offset, @query)
    end

    def new
      race = Racing::RaceSchedule.find(params[:race_id])
      @horse = Horses::Horse.racehorse.find(params[:horse_id])
      @entry = Racing::FutureRaceEntry.new(date: race.date, race:, horse: @horse)
      authorize @entry

      @entry.store_initial_options
      entry_ids = Racing::RaceEntry.where(horse: @horse).pluck(:race_id)
      entry_ids += Racing::FutureRaceEntry.where(horse: @horse).pluck(:race_id)
      @existing_schedules = Racing::RaceSchedule.where(id: entry_ids).pluck(:date)
      @min_days = if Current.user.setting&.racing&.apply_minimums_for_future_races
        Current.user.setting&.racing&.min_days_delay_from_last_race.to_i
      else
        0
      end
    end

    def edit
      race = Racing::RaceSchedule.find(params[:id])
      @horse = Horses::Horse.racehorse.find(params[:horse_id])
      @entry = @horse.future_race_entries.find_by(race:)
      authorize @entry

      entry_ids = Racing::RaceEntry.where(horse: @horse).pluck(:race_id)
      entry_ids += Racing::FutureRaceEntry.where(horse: @horse).pluck(:race_id)
      @existing_schedules = Racing::RaceSchedule.where(id: entry_ids).pluck(:date)
      @min_days = if Current.user.setting&.racing&.apply_minimums_for_future_races
        Current.user.setting&.racing&.min_days_delay_from_last_race.to_i
      else
        0
      end
    end

    def create
      race = Racing::RaceSchedule.find(entry_params[:race_id])
      @horse = Horses::Horse.racehorse.find(params[:horse_id])
      @entry = Racing::FutureRaceEntry.new(date: race.date, race:, horse: @horse)
      @entry.store_initial_options
      authorize @entry

      result = Racing::FutureEntryCreator.new.create_entry(**entry_creator_params(race))
      if result.created?
        flash[:success] = t(".success", name: @horse.name)
        redirect_to horse_path(@horse)
      else
        entry_ids = Racing::RaceEntry.where(horse: @horse).pluck(:race_id)
        entry_ids += Racing::FutureRaceEntry.where(horse: @horse).pluck(:race_id)
        @existing_schedules = Racing::RaceSchedule.where(id: entry_ids).pluck(:date)
        @min_days = if Current.user.setting&.racing&.apply_minimums_for_future_races
          Current.user.setting&.racing&.min_days_delay_from_last_race.to_i
        else
          0
        end
        flash[:error] = t(".failure", name: @horse.name)
        respond_to do |format|
          format.html { redirect_to horse_path(@horse) }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("race-entry-form", partial: "horse/future_races/form", locals: { entry: result.entry, horse: @horse, error: result.error, url: horse_future_races_path(@horse) })
          end
        end
      end
    end

    def update
      @entry = Racing::FutureRaceEntry.find(params[:id])
      race = @entry.race
      @horse = @entry.horse
      authorize @entry

      result = Racing::FutureEntryUpdater.new.update_entry(**entry_updater_params(@entry))
      if result.updated?
        flash[:success] = t(".success", name: @horse.name)
        redirect_to horse_path(@horse)
      else
        entry_ids = Racing::RaceEntry.where(horse: @horse).pluck(:race_id)
        entry_ids += Racing::FutureRaceEntry.where(horse: @horse).pluck(:race_id)
        @existing_schedules = Racing::RaceSchedule.where(id: entry_ids).pluck(:date)
        @min_days = if Current.user.setting&.racing&.apply_minimums_for_future_races
          Current.user.setting&.racing&.min_days_delay_from_last_race.to_i
        else
          0
        end
        flash[:error] = t(".failure", name: @horse.name)
        respond_to do |format|
          format.html { redirect_to horse_path(@horse) }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("race-entry-form", partial: "horse/future_races/form", locals: { entry: result.entry, horse: @horse, error: result.error, url: racing_race_entry_option_path(race, result.entry) })
          end
        end
      end
    end

    def destroy
      @horse = Horses::Horse.racehorse.find(params[:horse_id])
      @entry = @horse.future_race_entries.find_by(race_id: params[:id])
      authorize @entry

      @current_entries = @horse.race_entries.order(date: :asc)
      @scheduled_entries = @horse.future_race_entries.includes(race: :track_surface).order(date: :asc)
      if @entry.destroy!
        flash.now[:success] = t(".success")
      else
        flash.now[:error] = t(".failure")
      end
      respond_to do |format|
        format.html { redirect_to horse_path(@horse) }
        format.turbo_stream { render :destroy }
      end
    end

    private

    def entry_updater_params(entry)
      {
        entry:, stable: Current.stable, racing_style: entry_params[:racing_style],
        first_jockey: entry_params[:first_jockey], second_jockey: entry_params[:second_jockey],
        third_jockey: entry_params[:third_jockey], shipping_mode: entry_params[:ship_mode],
        shipping_date: entry_params[:ship_date], auto_enter: entry_params[:auto_enter],
        ship_only_if_horse_is_entered: entry_params[:ship_only_if_horse_is_entered],
        blinkers: entry_params[:blinkers], shadow_roll: entry_params[:shadow_roll],
        wraps: entry_params[:wraps], no_whip: entry_params[:no_whip], figure_8: entry_params[:figure_8]
      }
    end

    def entry_creator_params(race)
      {
        race:, horse: @horse, stable: Current.stable, racing_style: entry_params[:racing_style],
        first_jockey: entry_params[:first_jockey], second_jockey: entry_params[:second_jockey],
        third_jockey: entry_params[:third_jockey], shipping_mode: entry_params[:ship_mode],
        shipping_date: entry_params[:ship_date], auto_enter: entry_params[:auto_enter],
        ship_only_if_horse_is_entered: entry_params[:ship_only_if_horse_is_entered],
        blinkers: entry_params[:blinkers], shadow_roll: entry_params[:shadow_roll],
        wraps: entry_params[:wraps], no_whip: entry_params[:no_whip], figure_8: entry_params[:figure_8]
      }
    end

    def entry_params
      params.expect(racing_future_race_entry: [:race_id, :racing_style, :first_jockey, :second_jockey, :third_jockey, :ship_mode, :ship_date, :ship_only_if_horse_is_entered, :auto_enter, :blinkers, :shadow_roll, :wraps, :no_whip, :figure_8])
    end
  end
end

