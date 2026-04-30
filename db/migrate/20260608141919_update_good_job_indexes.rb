class UpdateGoodJobIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :good_jobs, :retried_good_job_id, if_not_exists: true, algorithm: :concurrently
  end
end

