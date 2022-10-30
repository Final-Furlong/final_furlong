class HorseColour
  COLOURS = {
    bay: "bay", black: "black", blood_bay: "blood bay", blue_roan: "blue roan", brown: "brown",
    chestnut: "chestnut", dapple_grey: "dapple grey", dark_bay: "dark bay", dark_grey: "dark grey",
    flea_bitten_grey: "flea-bitten grey", grey: "grey", light_bay: "light bay",
    light_chestnut: "light chestnut", light_grey: "light grey", liver_chestnut: "liver chestnut",
    mahogany_bay: "mahogany bay", red_chestnut: "red chestnut", strawberry_roan: "strawberry roan"
  }

  ABBREVIATIONS = {
    bay: "b.", black: "blk.", blood_bay: "bld b.", blue_roan: "bl rn.", brown: "br.", chestnut: "ch.",
    dapple_grey: "gr.", dark_bay: "dkb.", dark_grey: "dk gr.", flea_bitten_grey: "gr.", grey: "gr.",
    light_bay: "lt b.", light_chestnut: "lt ch.", light_grey: "gr.", liver_chestnut: "ch.",
    mahogany_bay: "b.", red_chestnut: "ch.", strawberry_roan: "s rn."
  }

  attr_reader :colour

  def initialize(colour)
    @colour = colour.to_s
  end

  def to_s
    colour
  end

  def abbreviation
    ABBREVIATIONS[colour.to_sym]
  end
end

