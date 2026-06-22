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

    association :race_entry, blueprint: ::Racing::RaceEntryBlueprint do |horse, options|
      horse.race_entries.order(date: :asc).first
    end
  end
end

