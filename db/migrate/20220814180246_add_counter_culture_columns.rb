class AddCounterCultureColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :horses, :foals_count, :integer, null: false, default: 0
    add_column :horses, :unborn_foals_count, :integer, null: false, default: 0

    add_column :stables, :horses_count, :integer, null: false, default: 0
    add_column :stables, :bred_horses_count, :integer, null: false, default: 0
    add_column :stables, :unborn_horses_count, :integer, null: false, default: 0
  end
end

