class AddOnlineTimestampToStable < ActiveRecord::Migration[7.0]
  def change
    add_column :stables, :last_online_at, :datetime
    add_index :stables, :last_online_at
  end
end
