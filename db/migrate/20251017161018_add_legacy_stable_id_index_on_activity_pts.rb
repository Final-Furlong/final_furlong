class AddLegacyStableIdIndexOnActivityPts < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :activity_points, :legacy_stable_id, algorithm: :concurrently
  end
end

