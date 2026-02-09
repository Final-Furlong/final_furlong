module Game
  class MoneyFormatter
    attr_reader :amount

    def initialize(amount)
      @amount = amount
    end

    def to_s
      ActiveSupport::NumberHelper.number_to_currency(amount, unit: Config::Game.currency, precision: 0)
    end
  end
end

