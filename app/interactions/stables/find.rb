module Stables
  class Find < BaseInteraction
    integer :id

    def execute
      stable = Account::Stable.find_by(id:)

      stable || errors.add(:id, "does not exist")
    end
  end
end

