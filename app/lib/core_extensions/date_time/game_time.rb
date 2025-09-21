module CoreExtensions
  module DateTime
    module GameTime
      def from_game_time
        self - 4.years
      end

      def to_game_time
        self + 4.years
      end
    end
  end
end

