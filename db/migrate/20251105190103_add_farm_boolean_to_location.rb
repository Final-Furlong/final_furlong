class AddFarmBooleanToLocation < ActiveRecord::Migration[8.1]
  def change
    add_column :locations, :has_farm, :boolean, default: true, null: false
  end
end

