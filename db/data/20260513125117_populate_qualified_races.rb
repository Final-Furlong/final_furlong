class PopulateQualifiedRaces < ActiveRecord::Migration[8.1]
  def up
    Racing::RaceSchedule.where(name: race_names).find_each do |race|
      race.update(requires_qualification: true)
    end
  end

  def down
    # rubocop:disable Rails/SkipsModelValidations
    Racing::RaceSchedule.update_all(requires_qualification: false)
    # rubocop:enable Rails/SkipsModelValidations
  end

  private

  def race_names
    [
      "Breeders' Cup Distaff",
      "Breeders' Cup Juvenile Fillies",
      "Breeders' Cup Mile",
      "Breeders' Cup Sprint",
      "Breeders' Cup Filly & Mare Turf",
      "Breeders' Cup Juvenile",
      "Breeders' Cup Turf",
      "Breeders' Cup Classic",
      "Breeders' Cup SC Sprint",
      "Breeders' Cup SC Classic",
      "Breeders' Cup SC Endurance",
      "Breeders' Cup SC Distaff",
      "Breeders' Cup SC Distaff Endurance",
      "Breeders' Cup Juvenile Turf",
      "Breeders' Cup Filly & Mare Sprint",
      "Breeders' Cup Dirt Mile",
      "Breeders' Cup Juvenile Turf Fillies",
      "Breeders' Cup Turf Sprint",
      "Moonover Boy Breeders' Stakes",
      "Townsend Holly Breeders' Stakes",
      "Rainbow Quest Breeders' Stakes",
      "Cross Roads Breeders' Stakes",
      "Crimson Lad Breeders' Stakes",
      "Demand To Know Breeders' Stakes",
      "Pardon Me Mister Breeders' Stakes",
      "Lymerick Breeders' Stakes",
      "Lucky Cigar Breeders' Stakes",
      "Secretariat Breeders' Stakes",
      "Valid Wager Breeders' Stakes",
      "Dark Magic Breeders' Stakes",
      "Amazon Princess Breeders' Stakes",
      "Fire de Flame Breeders' Stakes",
      "Highland Rogue Breeders' Stakes",
      "Backstage Pass Breeders' Stakes",
      "Planet Hollywood Breeders' Stakes",
      "What's It Worth Breeders' Stakes",
      "Lonesome Glory Breeders' Stakes",
      "Brandywine Breeders' Stakes",
      "Evening Flame Breeders' Stakes",
      "Ifyoucouldseemenow Breeders' Stakes",
      "Seabiscuit Breeders' Stakes",
      "Bold Ruler Breeders' Stakes",
      "A.P. Indy Breeders' Stakes",
      "With Approval Breeders' Stakes",
      "Nation's Pride Breeders' Stakes",
      "That's Debatable Breeders' Stakes",
      "Townsend Prince Breeders' Stakes",
      "Dream Skipper Breeders' Stakes",
      "Highland Bandit Breeders' Stakes",
      "Spectacular Bid Breeders' Stakes",
      "The Black Breeders' Stakes",
      "Seeing Starz Breeders' Stakes",
      "Hollywood Queen Breeders' Stakes",
      "Miss Hayday Breeders' Stakes",
      "Man O'War Breeders' Stakes",
      "Cigar Breeders' Stakes",
      "Omaha Breeders' Stakes",
      "Eternal Hope Breeders' Stakes",
      "Highland Sorceress Breeders' Stakes",
      "Highland Raven Breeders' Stakes"
    ]
  end
end

