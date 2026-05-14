class CreateBreedersCupTurfSprintQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_turf_sprint_qualifiers
  end
end

