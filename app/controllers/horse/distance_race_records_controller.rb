module Horse
  class DistanceRaceRecordsController < AuthenticatedController
    def show
      @horse = Horses::Horse.find(params[:id])
      @record = @horse.distance_race_record
      authorize @record
    end
  end
end

