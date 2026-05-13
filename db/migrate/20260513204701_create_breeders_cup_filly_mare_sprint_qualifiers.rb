class CreateBreedersCupFillyMareSprintQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_filly_mare_sprint_qualifiers
  end
end

