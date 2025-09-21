module CoreExtensions
  module Date
    module GameTime
      def from_game_date
        self - 4.years
      end

      def to_game_date
        self + 4.years
      end
    end
  end
end

