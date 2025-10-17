class AddLegacyIdToAccountActivity < ActiveRecord::Migration[8.0]
  def change
    add_column :activity_points, :legacy_stable_id, :integer, default: 0, null: false
  end
end

