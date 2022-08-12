module Stables
  class List < BaseInteraction
    def execute
      StablesRepository.new.ordered_by_name
    end
  end
end

