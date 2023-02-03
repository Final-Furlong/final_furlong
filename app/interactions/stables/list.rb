module Stables
  class List < BaseInteraction
    def execute
      Account::StablesRepository.new.ordered_by_name
    end
  end
end

