class CreateBreedersCupScSprintQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_sc_sprint_qualifiers
  end
end

