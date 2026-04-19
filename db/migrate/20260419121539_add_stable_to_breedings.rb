class AddStableToBreedings < ActiveRecord::Migration[8.1]
  def change
    add_reference :breedings, :stable, null: true, index: true, foreign_key: { to_table: :stables }
  end
end

