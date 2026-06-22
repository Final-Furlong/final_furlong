module Racing
  class InjuryBlueprint < Blueprinter::Base
    identifier :id

    fields :date, :injury_type, :rest_date
  end
end

