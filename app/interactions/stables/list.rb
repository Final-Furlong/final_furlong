module Stables
  class List < BaseInteraction
    def execute
      Account::StablesQuery.new.ordered_by_name
    end
  end
end

