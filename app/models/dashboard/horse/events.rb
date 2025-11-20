module Dashboard
  module Horse
    class Events
      attr_reader :horse

      def initialize(horse:)
        @horse = horse
      end
    end
  end
end

