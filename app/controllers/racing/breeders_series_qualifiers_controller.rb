module Racing
  class BreedersSeriesQualifiersController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      raise ActiveRecord::RecordNotFound unless Racing::RaceSchedule.breeders_series.current_year.exists?

      @series = Config::Racing.qualification_classes.select { |info| info.key?(:series) }
    end

    def show
      @series = Config::Racing.qualification_classes.find { |info| info[:series] == params[:id] }
      @series_key = @series[:series]
      gender = (@series_key.include?("filly") || @series_key.include?("mare")) ? "filly" : "colt"
      racehorse_type = @series_key.include?("steeplechase") ? "jump" : "flat"
      surface = if @series_key.include?("turf")
        "turf"
      else
        (@series_key.include?("dirt") ? "dirt" : "steeplechase")
      end
      @races = Racing::RaceSchedule.breeders_series.current_year.for_age(@series_key.to_s[0]).for_gender(gender).for_racehorse_type(racehorse_type).joins(:track_surface).merge(Racing::TrackSurface.send(surface)).all
      authorize @races.first, :view_qualifiers?
    end
  end
end

