class CreateJobStats < ActiveRecord::Migration[8.1]
  def change
    create_table :job_stats do |t|
      t.string :name, null: false, index: true
      t.datetime :last_run_at, index: true
      t.jsonb :outcome

      t.timestamps
    end
  end
end

