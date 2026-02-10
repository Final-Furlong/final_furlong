class AddLeaserIdToHorses < ActiveRecord::Migration[8.1]
  def change
    add_reference :horses, :leaser, index: true, foreign_key: { to_table: :stables }
  end
end

