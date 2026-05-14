class CreateBreedersCupClassicQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_classic_qualifiers
  end
end

