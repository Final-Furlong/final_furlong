FactoryBot.define do
  factory :legacy_race_record, class: "Legacy::RaceRecord" do
    Year { Date.current.year + 4 }
    sequence(:Horse)
    Starts { 5 }
    Wins { 0 }
    Seconds { 0 }
    Thirds { 0 }
    Fourths { 0 }
    Stakes { 0 }
    StakesWn { 0 }
    StakesSds { 0 }
    StakesTds { 0 }
    StakesFs { 0 }
    Points { 0 }
    Earnings { 0 }
    FlatSC { "F" }

    trait :winner do
      Wins { 1 }
      Points { 6 }
    end

    trait :placed do
      Seconds { 1 }
      Thirds { 1 }
      Points { 3 }
    end

    trait :stakes_winner do
      Stakes { 2 }
      StakesWn { 1 }
      Earnings { 20_000 }
      Points { 20 }
    end

    trait :stakes_placed do
      Stakes { 2 }
      StakesTds { 1 }
      Earnings { 10_000 }
      Points { 15 }
    end

    trait :final_furlong do
      Owner { 20 }
    end

    trait :sellable do
      can_be_sold { true }
    end

    trait :racehorse do
      Status { 3 }
      DOB { 1.year.from_now }
    end

    trait :stallion do
      Status { 7 }
      DOB { 2.years.ago }
    end

    trait :broodmare do
      Status { 1 }
      DOB { 2.years.ago }
    end

    trait :yearling do
      Status { 10 }
      DOB { 3.years.from_now }
    end

    trait :weanling do
      Status { 9 }
      DOB { 4.years.from_now }
    end

    trait :unborn do
      DOB { 49.months.from_now }
    end
  end
end

# == Schema Information
#
# Table name: ff_horses
#
#  Acceleration            :integer
#  Allele                  :string(50)
#  Approval                :string           default("N")
#  Ave                     :integer
#  BMBPF                   :integer
#  BPF                     :integer
#  Boarded                 :boolean          default(FALSE), not null, indexed
#  Break                   :integer
#  Breeder                 :integer          indexed
#  Close                   :integer
#  Color                   :integer
#  Comments                :text(4294967295)
#  Consistency             :integer
#  Courage                 :integer
#  CurrentHeight           :float(53)        default(0.0), not null
#  DC                      :string(3)        indexed
#  DOB                     :date             indexed, indexed => [Dam]
#  DOD                     :date             indexed
#  Dam                     :integer          indexed, indexed => [DOB], indexed => [Sire], indexed => [Status, Sire]
#  DamDam                  :integer          indexed
#  DamSire                 :integer          indexed
#  DefaultEquip            :integer
#  DefaultInstructions     :integer
#  DefaultJock1            :integer          indexed
#  DefaultJock2            :integer
#  DefaultJock3            :integer
#  DefaultWorkoutTrack     :integer
#  Die                     :date
#  Dirt                    :integer
#  DisplayEnergy           :string(1)        indexed, indexed => [EnergyCurrent]
#  DisplayFitness          :string(1)        indexed, indexed => [Fitness]
#  EnergyCurrent           :integer          indexed, indexed => [DisplayEnergy]
#  EnergyMin               :integer
#  EnergyRegain            :integer
#  Equipment               :integer
#  FFMares                 :boolean          default(FALSE), not null
#  Face                    :integer          default(3)
#  FacePic                 :integer          default(18)
#  Fast                    :integer
#  Fitness                 :integer          indexed, indexed, indexed => [DisplayFitness]
#  FoalHeight              :integer
#  GenSound                :integer
#  Gender                  :string           indexed
#  Good                    :integer
#  HBDate                  :date
#  Hasbeen                 :string(2)
#  Height                  :string(4)
#  ID                      :integer          not null, primary key
#  ImmDate                 :date
#  Immature                :string(2)
#  InTransit               :boolean          default(FALSE), not null
#  LFPic                   :integer          default(18)
#  LFmarkings              :integer          default(3)
#  LHPic                   :integer          default(18)
#  LHmarkings              :integer          default(3)
#  LastRaceFinishers       :integer
#  LastRaceId              :integer          indexed
#  Lead                    :integer
#  Leased                  :boolean          default(FALSE), not null, indexed, indexed => [Status, Owner]
#  LoafPct                 :integer          default(0), not null
#  LoafStride              :integer
#  LoafThresh              :integer
#  LocBred                 :integer          default(10), not null
#  Location                :integer          default(59), not null, indexed, indexed => [Status]
#  MaresPerStable          :integer          default(0)
#  Max                     :integer
#  Midpack                 :integer
#  Min                     :integer
#  NEGain                  :float(53)
#  NELoss                  :integer
#  Name                    :string(18)       indexed
#  NaturalEnergy           :float(53)        default(0.0), not null, indexed
#  Outside                 :integer          default(0)
#  Owner                   :integer          indexed, indexed => [Status], indexed => [Status, Leased], indexed => [SalePrice]
#  OwnerComments           :text(4294967295)
#  Pace                    :integer
#  Pissy                   :integer
#  RFPic                   :integer          default(18)
#  RFmarkings              :integer          default(3)
#  RHPic                   :integer          default(18)
#  RHmarkings              :integer          default(3)
#  RacesCount              :integer
#  Ratability              :integer
#  RestDayCount            :integer
#  Retire                  :date
#  SC                      :integer
#  SPS                     :float(53)
#  SalePrice               :integer          default(-1), indexed, indexed => [Owner]
#  SellTo                  :integer          default(0), indexed
#  Sire                    :integer          indexed, indexed => [Dam], indexed => [Status, Dam]
#  SireDam                 :integer          indexed
#  SireSire                :integer          indexed
#  Slow                    :integer
#  Soundness               :integer
#  Stamina                 :integer
#  Status                  :integer          indexed, indexed => [Sire, Dam], indexed => [Owner], indexed => [Owner, Leased], indexed => [Location]
#  StudPrice               :integer          default(-1)
#  Sustain                 :integer
#  Traffic                 :integer
#  Turf                    :integer
#  Turning                 :integer
#  Weight                  :integer
#  Wet                     :integer
#  XPCurrent               :integer
#  XPRate                  :integer
#  can_be_sold             :boolean          default(FALSE), not null
#  last_modified           :datetime         not null
#  last_synced_to_rails_at :datetime
#  leaser                  :integer          default(0), indexed
#  slug                    :string(255)
#  consigned_auction_id    :string(36)
#  rails_id                :string(36)
#
# Indexes
#
#  Boarded              (Boarded)
#  Breeder              (Breeder)
#  DC                   (DC)
#  DOB                  (DOB)
#  DOD                  (DOD)
#  Dam                  (Dam)
#  DamDam               (DamDam)
#  DamSire              (DamSire)
#  Dam_2                (Dam,DOB)
#  DefaultJock1         (DefaultJock1)
#  DisplayEnergy        (DisplayEnergy)
#  EnergyCurrent        (EnergyCurrent)
#  Fitness              (Fitness)
#  Gender               (Gender)
#  LastRace             (LastRaceId)
#  Leased               (Leased)
#  Leaser               (leaser)
#  Location             (Location)
#  Name                 (Name)
#  NatEn                (NaturalEnergy)
#  Owner                (Owner)
#  SalePrice            (SalePrice)
#  SellTo               (SellTo)
#  Sire                 (Sire)
#  SireDam              (SireDam)
#  SireSire             (SireSire)
#  Sire_2               (Sire,Dam)
#  Status               (Status)
#  Status_2             (Status,Sire,Dam)
#  Status_Owner         (Status,Owner)
#  Status_Owner_Leased  (Status,Owner,Leased)
#  idx_display_fitness  (DisplayFitness)
#  idx_energy_all       (DisplayEnergy,EnergyCurrent)
#  idx_fitness          (Fitness)
#  idx_fitness_all      (DisplayFitness,Fitness)
#  owner_price          (Owner,SalePrice)
#  status_location      (Status,Location)
#

