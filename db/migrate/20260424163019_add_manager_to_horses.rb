class AddManagerToHorses < ActiveRecord::Migration[8.1]
  def change
    add_reference :horses, :manager, index: true, foreign_key: { to_table: :stables }
  end
end

