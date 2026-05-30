module Horse
  class SpecificRaceRecordsController < AuthenticatedController
    def show
      @horse = Horses::Horse.includes(:distance_race_record, :surface_race_record, :condition_race_record,
        :race_type_race_record, :equipment_race_records, :location_race_records).find(params[:id])
      @distance_record = @horse.distance_race_record
      authorize @distance_record

      @surface_record = @horse.surface_race_record
      @condition_record = @horse.condition_race_record
      @race_type_record = @horse.race_type_race_record
      @equipment_records = @horse.equipment_race_records.order(equipment: :asc)
      @location_records = @horse.location_race_records.order(name: :asc)
    end
  end
end

