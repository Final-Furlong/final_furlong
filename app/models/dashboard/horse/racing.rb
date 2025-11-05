module Dashboard
  module Horse
    class Racing
      attr_reader :horse, :annual_race_records, :lifetime_race_record

      def initialize(horse:)
        @horse = horse
        @annual_race_records = horse.annual_race_records.sort_by(&:year)
        @lifetime_race_record = horse.lifetime_race_record
      end
    end
  end
end

