module Stables
  class List < BaseInteraction
    def execute
      Stable.ordered
    end
  end
end
