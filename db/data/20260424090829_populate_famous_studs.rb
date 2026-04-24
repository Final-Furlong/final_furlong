# frozen_string_literal: true

class PopulateFamousStuds < ActiveRecord::Migration[8.1]
  def up
    Horses::Horse.where(name: names).find_each do |horse|
      next unless horse.stud_foals.present? || horse.stud?

      Horses::Stud::FamousStud.find_or_create_by(horse:)
    end
  end

  def down
    Horses::Horse.where(name: names).find_each do |horse|
      next unless horse.stud_foals.present? || horse.stud?

      Horses::Stud::FamousStud.where(horse:).destroy
    end
  end

  private

  def names
    [
      "Sir Barton",
      "Man O'War",
      "Black Gold",
      "Gallant Fox",
      "Omaha",
      "Seabiscuit",
      "War Admiral",
      "Whirlaway",
      "Count Fleet",
      "The Black",
      "Assault",
      "Citation",
      "Native Dancer",
      "Bold Ruler",
      "Northern Dancer",
      "Secretariat",
      "Foolish Pleasure",
      "Affirmed",
      "Alydar",
      "Spectacular Bid",
      "Seattle Slew",
      "Deputy Minister",
      "Mr. Prospector",
      "Storm Cat",
      "Easy Goer",
      "Sunday Silence",
      "Unbridled",
      "Danzig",
      "Lonesome Glory",
      "Strike The Gold",
      "A.P. Indy",
      "Lit de Justice",
      "Cigar",
      "Rahy",
      "Giant's Causeway",
      "Sadler's Wells",
      "Tiznow",
      "War Chant",
      "Silver Charm",
      "Smart Strike",
      "Holy Bull",
      "Octagonal",
      "Rock of Gibraltar",
      "Invasor",
      "Sun King",
      "Empire Maker",
      "Monarchos",
      "Point Given",
      "Candy Ride",
      "Ghostzapper",
      "Deep Impact",
      "Sea the Stars",
      "Frankel",
      "Animal Kingdom",
      "Curlin",
      "Bernardini",
      "Mucho Macho Man",
      "American Pharoah",
      "Dunaden",
      "Blame",
      "Frosted",
      "California Chrome",
      "Golden Horn",
      "Dubawi",
      "Talismanic",
      "Gun Runner",
      "Thunder Snow",
      "City of Light",
      "Authentic",
      "Nyquist",
      "Knicks Go",
      "Cody's Wish",
      "Flightline",
      "War Front",
      "Justify",
      "Essential Quality",
      "Into Mischief",
      "Seize the Grey",
      "Iffraaj",
      "Lope de Vega",
      "Maurice",
      "Oscar Performance",
      "Starman",
      "Street Boss",
      "Auguste Rodin"
    ]
  end
end

