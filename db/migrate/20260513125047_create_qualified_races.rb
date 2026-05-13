class CreateQualifiedRaces < ActiveRecord::Migration[8.1]
  def change
    add_column :race_schedules, :requires_qualification, :boolean, default: false, null: false
    add_index :race_schedules, :requires_qualification
  end
end

