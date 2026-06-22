module Horses
  class RacehorseBlueprint < ::Blueprinter::Base
    identifier :id

    fields :name, :gender, :status, :owner_id, :breeder_id,
      :date_of_birth, :age, :date_of_death, :sire_id, :dam_id

    field :owner_name do |horse, options|
      horse.owner.name
    end

    field :breeder_name do |horse, options|
      horse.breeder.name
    end

    association :racing_stats, blueprint: ::Racing::RacingStatsBlueprint
  end
end

