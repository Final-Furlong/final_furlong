module Stables
  class Find < BaseInteraction
    string :id

    def execute
      stable = Stable.find_by(id:)

      stable || errors.add(:id, "does not exist")
    end
  end
end

