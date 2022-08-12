class LegacyHorse < LegacyRecord
  self.table_name = "ff_horses"
  self.primary_key = "ID"

  def method_missing(method_name, *_args)
    self[format_attribute(method_name)]
  end

  def respond_to_missing?(method_name, include_private = false)
    lookup_methods.include?(method_name.to_s) || super
  end

  private

  def format_attribute(value)
    # rubocop:disable Metrics/MethodLength
    value = value.to_s
    case value
    when "secondary_bloodline_power"
      "BMBPF"
    when "bloodline_power"
      "BPF"
    when "dosage"
      "DC"
    when "date_of_birth"
      "DOB"
    when "date_of_death"
      "DOD"
    when "game_mares_allowed"
      "FFMares"
    else
      value.titleize.delete(" ")
    end
  end

  def lookup_methods
    %w[Acceleration Allele Approval Ave BMBPF BPF Boarded Break Breeder
       Close Color Comments Consistency Courage CurrentHeight DC DOB Dam
       DamDam DamSire DefaultEquip DefaultInstructions DefaultJock1 DefaultJock2
       DefaultJock3 DefaultWorkoutTrack Die Dirt DisplayEnergy DisplayFitness
       EnergyCurrent EnergyMin EnergyRegain Equipment FFMares Face FacePic
       Fast Fitness FoalHeight GenSound Gender Good Hasbeen Height ID
       Immature InTransit LFPic LFmarkings LHPic LHmarkings LastRaceFinishers
       LastRaceId Lead Leased LoafPct LoafStride LoafThresh LocBred Location
       MaresPerStable Max Midpack Min NEGain NELoss Name NaturalEnergy Outside
       Owner OwnerComments Pace Pissy RFPic RFmarkings RHPic RHmarkings RacesCount
       Ratability RestDayCount Retire SC SPS SalePrice SellTo Sire SireDam SireSire
       Slow Soundness Stamina Status StudPrice Sustain Traffic Turf Turning Weight
       Wet XPCurrent XPRate can_be_sold last_modified leaser slug]
  end
end

# == Schema Information
#
# Table name: ff_horses
#
#  Acceleration        :integer
#  Allele              :string(50)
#  Approval            :string           default("N")
#  Ave                 :integer
#  BMBPF               :integer
#  BPF                 :integer
#  Boarded             :boolean          default(FALSE), not null, indexed
#  Break               :integer
#  Breeder             :integer          indexed
#  Close               :integer
#  Color               :integer
#  Comments            :text(4294967295)
#  Consistency         :integer
#  Courage             :integer
#  CurrentHeight       :float(53)        default(0.0), not null
#  DC                  :string(3)        indexed
#  DOB                 :date             indexed, indexed => [Dam]
#  DOD                 :date             indexed
#  Dam                 :integer          indexed, indexed => [DOB], indexed => [Sire], indexed => [Status, Sire]
#  DamDam              :integer          indexed
#  DamSire             :integer          indexed
#  DefaultEquip        :integer
#  DefaultInstructions :integer
#  DefaultJock1        :integer          indexed
#  DefaultJock2        :integer
#  DefaultJock3        :integer
#  DefaultWorkoutTrack :integer
#  Die                 :date             default(NULL), not null
#  Dirt                :integer
#  DisplayEnergy       :string(1)        indexed, indexed => [EnergyCurrent]
#  DisplayFitness      :string(1)        indexed, indexed => [Fitness]
#  EnergyCurrent       :integer          indexed, indexed => [DisplayEnergy]
#  EnergyMin           :integer
#  EnergyRegain        :integer
#  Equipment           :integer
#  FFMares             :boolean          default(FALSE), not null
#  Face                :integer          default(3)
#  FacePic             :integer          default(18)
#  Fast                :integer
#  Fitness             :integer          indexed, indexed, indexed => [DisplayFitness]
#  FoalHeight          :integer
#  GenSound            :integer
#  Gender              :string           indexed
#  Good                :integer
#  HBDate              :date
#  Hasbeen             :string(2)
#  Height              :string(4)
#  ID                  :integer          not null, primary key
#  ImmDate             :date
#  Immature            :string(2)
#  InTransit           :boolean          default(FALSE), not null
#  LFPic               :integer          default(18)
#  LFmarkings          :integer          default(3)
#  LHPic               :integer          default(18)
#  LHmarkings          :integer          default(3)
#  LastRaceFinishers   :integer
#  LastRaceId          :integer          indexed
#  Lead                :integer
#  Leased              :boolean          default(FALSE), not null, indexed, indexed => [Status, Owner]
#  LoafPct             :integer          default(0), not null
#  LoafStride          :integer
#  LoafThresh          :integer
#  LocBred             :integer          default(10), not null
#  Location            :integer          default(59), not null, indexed, indexed => [Status]
#  MaresPerStable      :integer          default(0)
#  Max                 :integer
#  Midpack             :integer
#  Min                 :integer
#  NEGain              :float(53)
#  NELoss              :integer
#  Name                :string(18)       indexed
#  NaturalEnergy       :float(53)        default(0.0), not null, indexed
#  Outside             :integer          default(0)
#  Owner               :integer          indexed, indexed => [Status], indexed => [Status, Leased], indexed => [SalePrice]
#  OwnerComments       :text(4294967295)
#  Pace                :integer
#  Pissy               :integer
#  RFPic               :integer          default(18)
#  RFmarkings          :integer          default(3)
#  RHPic               :integer          default(18)
#  RHmarkings          :integer          default(3)
#  RacesCount          :integer
#  Ratability          :integer
#  RestDayCount        :integer
#  Retire              :date             default(NULL), not null
#  SC                  :integer
#  SPS                 :float(53)
#  SalePrice           :integer          default(-1), indexed, indexed => [Owner]
#  SellTo              :integer          default(0), indexed
#  Sire                :integer          indexed, indexed => [Dam], indexed => [Status, Dam]
#  SireDam             :integer          indexed
#  SireSire            :integer          indexed
#  Slow                :integer
#  Soundness           :integer
#  Stamina             :integer
#  Status              :integer          indexed, indexed => [Sire, Dam], indexed => [Owner], indexed => [Owner, Leased], indexed => [Location]
#  StudPrice           :integer          default(-1)
#  Sustain             :integer
#  Traffic             :integer
#  Turf                :integer
#  Turning             :integer
#  Weight              :integer
#  Wet                 :integer
#  XPCurrent           :integer
#  XPRate              :integer
#  can_be_sold         :boolean          default(FALSE), not null
#  last_modified       :datetime         not null
#  leaser              :integer          default(0), indexed
#  slug                :string(255)
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
