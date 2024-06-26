module Horses
  class Color
    VALUES = {
      bay: "bay",
      black: "black",
      blood_bay: "blood_bay",
      blue_roan: "blue_roan",
      brown: "brown",
      chestnut: "chestnut",
      dapple_grey: "dapple_grey",
      dark_bay: "dark_bay",
      dark_grey: "dark_grey",
      flea_bitten_grey: "flea_bitten_grey",
      grey: "grey",
      light_bay: "light_bay",
      light_chestnut: "light_chestnut",
      light_grey: "light_grey",
      liver_chestnut: "liver_chestnut",
      mahogany_bay: "mahogany_bay",
      red_chestnut: "red_chestnut",
      strawberry_roan: "strawberry_roan"
    }.freeze

    def initialize(color)
      @color = color.to_s
    end

    def to_s
      @color.titleize
    end
  end
end

