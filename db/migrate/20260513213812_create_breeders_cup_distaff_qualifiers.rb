class CreateBreedersCupDistaffQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_distaff_qualifiers
  end
end

