module Dashboard
  module Horse
    class Foals
      attr_reader :horse, :born_foals, :unborn_foal, :unborn_foals, :breeding_record,
        :born_foals_count, :stillborn_foals_count, :crops_count, :crops_list, :pagy

      def initialize(horse:, pagy:, born_foals: [])
        @horse = horse
        @pagy = pagy
        if horse.female?
          @born_foals = born_foals
          @unborn_foal = horse.next_foal
          @breeding_record = horse.foal_record || horse.build_foal_record
        else
          @breeding_record = horse.foal_record || horse.build_foal_record
          if @pagy.page == 1
            @crops_count = breeding_record.crops_count
            @crops_list = horse.foals.group("DATE_PART('Year', date_of_birth)").count.sort
          end
          @born_foals = born_foals
          @unborn_foals = horse.breedings.bred.by_year(Date.current.year).includes(:mare).order(mare: { name: :asc })
        end
      end
    end
  end
end

