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
      stakes_string(starts, stakes_starts)
    end

    def wins_string
      stakes_string(wins, stakes_wins)
    end

    def seconds_string
      stakes_string(seconds, stakes_seconds)
    end

    def thirds_string
      stakes_string(thirds, stakes_thirds)
    end

    def fourths_string
      stakes_string(fourths, stakes_fourths)
    end

    def earnings_string
      ActiveSupport::NumberHelper.number_to_currency(earnings, unit: "$", precision: 0)
    end

    private

    def stakes_string(basic, stakes)
      value = basic.to_s
      value += "(#{stakes})" if stakes.positive?
      value
    end
  end
end

