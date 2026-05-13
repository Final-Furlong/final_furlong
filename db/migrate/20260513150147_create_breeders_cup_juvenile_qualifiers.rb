class CreateBreedersCupJuvenileQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_juvenile_qualifiers
  end
end

