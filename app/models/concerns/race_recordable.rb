module RaceRecordable
  extend ActiveSupport::Concern

  included do
    def places
      seconds + thirds
    end

    def stakes_places
      stakes_seconds + stakes_thirds
    end

    def starts_string
      stakes_string(starts.to_i, stakes_starts.to_i)
    end

    def wins_string
      stakes_string(wins.to_i, stakes_wins.to_i)
    end

    def seconds_string
      stakes_string(seconds.to_i, stakes_seconds.to_i)
    end

    def thirds_string
      stakes_string(thirds.to_i, stakes_thirds.to_i)
    end

    def fourths_string
      stakes_string(fourths.to_i, stakes_fourths.to_i)
    end

    def earnings_string
      Game::MoneyFormatter.new(earnings).to_s
    end

    private

    def stakes_string(basic, stakes)
      value = basic.to_s
      value += "(#{stakes})" if stakes.positive?
      value
    end
  end
end

