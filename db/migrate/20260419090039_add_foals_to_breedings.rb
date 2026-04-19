class AddFoalsToBreedings < ActiveRecord::Migration[8.1]
  def change
    add_reference :breedings, :first_foal, null: true, index: true, foreign_key: { to_table: :horses }
    add_reference :breedings, :second_foal, null: true, index: true, foreign_key: { to_table: :horses }
  end
end

