class AddDateOfBirthToFamousStudNomination < ActiveRecord::Migration[8.1]
  def change
    add_column :famous_stud_nominations, :date_of_birth, :date, null: false
  end
end

