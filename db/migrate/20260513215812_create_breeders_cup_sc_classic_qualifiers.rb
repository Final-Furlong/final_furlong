class CreateBreedersCupScClassicQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_sc_classic_qualifiers
  end
end

