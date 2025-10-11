class CreateGameAlerts < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    create_table :game_alerts, id: :uuid do |t|
      t.timestamp :start_time, null: false, index: { algorithm: :concurrently }
      t.timestamp :end_time, index: { algorithm: :concurrently }
      t.text :message, null: false
      t.boolean :display_to_newbies, default: true, null: false
      t.boolean :display_to_non_newbies, default: true, null: false

      t.timestamps
    end
  end
end

