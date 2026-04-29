class AddTitleDosageFieldsToHorses < ActiveRecord::Migration[8.1]
  def change
    add_column :horses, :title_abbr, :string
    add_column :horses, :dosage_abbr, :string
  end
end

