class CreateBreedersCupFillyMareTurfQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_filly_mare_turf_qualifiers
  end
end

