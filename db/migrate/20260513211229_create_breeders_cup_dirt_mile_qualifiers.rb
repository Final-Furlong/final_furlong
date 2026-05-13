class CreateBreedersCupDirtMileQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_dirt_mile_qualifiers
  end
end

