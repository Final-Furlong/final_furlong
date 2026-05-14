class CreateBreedersCupScDistaffQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_sc_distaff_qualifiers
  end
end

