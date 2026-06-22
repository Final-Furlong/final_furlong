module Racing
  class HorseJockeyRelationshipBlueprint < Blueprinter::Base
    identifier :id

    fields :experience, :happiness
  end
end

