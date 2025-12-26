module Dashboard
  module Horse
    class Boarding
      attr_reader :horse, :boardings, :current_boarding

      def initialize(horse:)
        @horse = horse
        @boardings = []
        @boardings = load_boardings
        @current_boardings = @boardings.first if @boardings.present? && !@boardings.first.current?
      end

      private

      def load_boardings
        query = Horses::Boarding.where(horse:)
        Horses::BoardingPolicy::Scope.new(Current.user, query).resolve.order(end_date: :desc, start_date: :desc)
      end
    end
  end
end

