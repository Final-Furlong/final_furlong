class CreateBreedersCupScEnduranceQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_sc_endurance_qualifiers
  end
end

