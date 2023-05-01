module ModelValidations
  # require_relative 'models/all'
  module Account
    class << self
      def stable = Dry::Validation::Contract do
        params do
          required(:description).value(:string)
        end

        rule(:description) do
          key.add(:too_short, count: 5) if value.length < 5
          key.add(:too_long, count: 1000) if value.length > 1000
        end
      end
    end
  end
end
