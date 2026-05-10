class CreateUserActivities < ActiveRecord::Migration[8.1]
  def change
    _user_activies = %w[
      bought_horse
      sold_horse
      entered_race
      bred_stud
      bred_mare
      view_race_results
      view_recent_foals
    ]
    create_table :user_activities do |t|
      t.references :user, type: :bigint, null: false, index: true, foreign_key: { to_table: :users }
      t.jsonb :activities, default: {}

      t.timestamps
    end

    add_index :user_activities, :activities, using: :gin
  end
end

