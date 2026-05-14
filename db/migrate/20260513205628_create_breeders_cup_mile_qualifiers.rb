class CreateBreedersCupMileQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_mile_qualifiers
  end
end

