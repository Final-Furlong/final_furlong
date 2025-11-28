module Dashboard
  module Horse
    class Racing
      attr_reader :horse, :annual_race_record, :annual_race_records, :lifetime_race_record, :races

      def initialize(horse:, year: nil)
        @horse = horse
        @annual_race_records = horse.annual_race_records.sort_by(&:year)
        if year
          @annual_race_record = horse.annual_race_records.find_by(year:)
          @races = horse.race_result_finishes.by_year(year)
        else
          @lifetime_race_record = horse.lifetime_race_record
        end
      end
    end
  end
end

