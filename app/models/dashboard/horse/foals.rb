module Dashboard
  module Horse
    class Foals
      attr_reader :horse, :born_foals, :unborn_foal, :unborn_foals, :breeding_record,
        :born_foals_count, :stillborn_foals_count, :crops_count, :crops_list

      def initialize(horse:)
        @horse = horse
        if horse.female?
          @born_foals = horse.foals.born.includes(:sire, :horse_attributes).order(date_of_birth: :asc)
          @unborn_foal = horse.next_foal.includes(:stud)
          @breeding_record = horse.broodmare_foal_record || horse.build_broodmare_foal_record
        else
          @breeding_record = horse.stud_foal_record || horse.build_stud_foal_record
          @crops_count = breeding_record.crops_count
          @crops_list = horse.stud_foals.group("DATE_PART('Year', date_of_birth)").count.sort
          @born_foals = horse.stud_foals.born.includes(:dam, :horse_attributes).order(date_of_birth: :asc)
          @unborn_foals = horse.breedings.bred.by_year(Date.current.year).includes(:mare).order(mare: { name: :asc })
        end
      end
    end
  end
end

