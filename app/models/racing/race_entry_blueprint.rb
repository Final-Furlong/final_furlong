module Racing
  class RaceEntryBlueprint < Blueprinter::Base
    identifier :horse_id

    fields :equipment, :post_parade, :jockey_id, :weight, :racing_style

    field :display_odds do |entry, options|
      entry.odd&.display
    end

    field :odds_dec do |entry, options|
      entry.odd&.value
    end
  end
end

