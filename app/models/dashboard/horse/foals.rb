module Dashboard
  module Horse
    class Foals
      attr_reader :horse, :born_foals, :unborn_foal, :unborn_foals, :breeding_record,
        :born_foals_count, :stillborn_foals_count, :crops_count

      def initialize(horse:)
        @horse = horse
        if horse.female?
          @born_foals = horse.foals.born.includes(:sire, :horse_attributes).order(date_of_birth: :asc)
          @born_foals_count = @born_foals.count
          @stillborn_foals_count = horse.foals.born.stillborn.count
          @unborn_foal = horse.foals.unborn.includes(:sire).order(date_of_birth: :asc).first
          @breeding_record = horse.broodmare_foal_record || horse.build_broodmare_foal_record
        else
          @born_foals = horse.stud_foals.includes(:dam, :horse_attributes).order_by_yob.order(name: :asc)
          @born_foals_count = @born_foals.count
          @stillborn_foals_count = horse.stud_foals.born.stillborn.count
          crops = horse.stud_foals.born.group("TO_CHAR(date_of_birth, 'YYYY')").count
          @crops_count = crops.values.count
          @breeding_record = nil
        end
      end
    end
  end
end

