# frozen_string_literal: true

class SetFamousStudDeaths < ActiveRecord::Migration[8.1]
  def up
    horses.each do |horse|
      this_horse = Horses::Horse.find_by(name: horse[:name])
      dob = this_horse.date_of_birth + 4.years
      dod = Date.parse(horse[:date])
      age = dod.year - dob.year
      this_horse.update(state: "deceased", date_of_birth: dob, date_of_death: dod, age:)
    end
    living_horses.each do |name|
      horse = Horses::Horse.find_by(name:)
      dob = horse.date_of_birth + 4.years
      age = Date.current.year - dob.year
      horse.update(date_of_birth: dob, age:)
    end
  end

  def down
    horses.each do |horse|
      Horses::Horse.where(name: horse[:name]).update(state: "retired", date_of_death: nil, age: horse[:age])
    end
  end

  private

  def horses
    [
      { name: "A.P. Indy", date: "2020-02-21", age: 30 },
      { name: "Affirmed", date: "2001-01-12", age: 25 },
      { name: "Alydar", date: "1990-11-15", age: 15 },
      { name: "Assault", date: "1971-09-01", age: 28 },
      { name: "Bernardini", date: "2021-07-30", age: 18 },
      { name: "Black Gold", date: "1928-01-18", age: 7 },
      { name: "Bold Ruler", date: "1971-07-12", age: 17 },
      { name: "Cigar", date: "2014-10-07", age: 24 },
      { name: "Citation", date: "1970-08-08", age: 25 },
      { name: "Count Fleet", date: "1973-12-03", age: 33 },
      { name: "Danzig", date: "2006-01-04", age: 28 },
      { name: "Deep Impact", date: "2019-07-30", age: 17 },
      { name: "Deputy Minister", date: "2004-09-10", age: 25 },
      { name: "Dunaden", date: "2019-04-30", age: 13 },
      { name: "Easy Goer", date: "1994-05-12", age: 8 },
      { name: "Empire Maker", date: "2020-01-18", age: 20 },
      { name: "Foolish Pleasure", date: "1994-11-17", age: 22 },
      { name: "Frosted", date: "2026-04-15", age: 14 },
      { name: "Gallant Fox", date: "1954-11-13", age: 27 },
      { name: "Giant's Causeway", date: "2018-04-16", age: 21 },
      { name: "Holy Bull", date: "2017-06-07", age: 26 },
      { name: "Lit de Justice", date: "2012-07-20", age: 22 },
      { name: "Lonesome Glory", date: "2002-02-25", age: 14 },
      { name: "Man O'War", date: "1947-11-01", age: 30 },
      { name: "Mr. Prospector", date: "1999-06-01", age: 29 },
      { name: "Monarchos", date: "2016-10-22", age: 18 },
      { name: "Native Dancer", date: "1967-11-16", age: 17 },
      { name: "Northern Dancer", date: "1990-11-16", age: 29 },
      { name: "Octagonal", date: "2016-10-15", age: 24 },
      { name: "Omaha", date: "1959-04-24", age: 27 },
      { name: "Point Given", date: "2023-09-11", age: 25 },
      { name: "Rahy", date: "2011-09-22", age: 26 },
      { name: "Rock of Gibraltar", date: "2022-10-23", age: 23 },
      { name: "Sadler's Wells", date: "2011-04-26", age: 30 },
      { name: "Seabiscuit", date: "1947-05-17", age: 14 },
      { name: "Seattle Slew", date: "2002-05-07", age: 28 },
      { name: "Secretariat", date: "1989-10-04", age: 19 },
      { name: "Sir Barton", date: "1937-10-30", age: 21 },
      { name: "Smart Strike", date: "2015-03-25", age: 22 },
      { name: "Spectacular Bid", date: "2003-06-09", age: 27 },
      { name: "Storm Cat", date: "2013-04-24", age: 30 },
      { name: "Strike The Gold", date: "2011-12-13", age: 23 },
      { name: "Sun King", date: "2023-12-02", age: 21 },
      { name: "Sunday Silence", date: "2002-08-19", age: 16 },
      { name: "The Black", date: "1963-06-01", age: 26 },
      { name: "Unbridled", date: "2001-10-18", age: 14 },
      { name: "War Admiral", date: "1959-10-30", age: 25 },
      { name: "War Chant", date: "2024-04-11", age: 27 },
      { name: "Whirlaway", date: "1953-04-06", age: 15 }
    ]
  end

  def living_horses
    [
      "American Pharoah",
      "Animal Kingdom",
      "Auguste Rodin",
      "Authentic",
      "Blame",
      "California Chrome",
      "Candy Ride",
      "City of Light",
      "Cody's Wish",
      "Curlin",
      "Dubawi",
      "Essential Quality",
      "Flightline",
      "Frankel",
      "Ghostzapper",
      "Golden Horn",
      "Gun Runner",
      "Iffraaj",
      "Into Mischief",
      "Invasor",
      "Justify",
      "Knicks Go",
      "Lope de Vega",
      "Maurice",
      "Mucho Macho Man",
      "Nyquist",
      "Oscar Performance",
      "Sea the Stars",
      "Seize the Grey",
      "Silver Charm",
      "Starman",
      "Street Boss",
      "Talismanic",
      "Thunder Snow",
      "Tiznow",
      "War Front"
    ]
  end
end

