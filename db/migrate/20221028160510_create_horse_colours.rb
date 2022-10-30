class CreateHorseColours < ActiveRecord::Migration[7.0]
  def change
    colours = [
      "bay",
      "black",
      "blood bay",
      "blue roan",
      "brown",
      "chestnut",
      "dapple grey",
      "dark bay",
      "dark grey",
      "flea-bitten grey",
      "grey",
      "light bay",
      "light chestnut",
      "light grey",
      "liver chestnut",
      "mahogany bay",
      "red chestnut",
      "strawberry roan"
    ]
    create_enum :horse_colour, colours

    add_column :horses, :colour, :string, enum_type: "horse_colour", default: "bay", null: false
  end
end

