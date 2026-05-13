class CreateBreedersCupJuvenileFilliesQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_juvenile_fillies_qualifiers
  end
end

