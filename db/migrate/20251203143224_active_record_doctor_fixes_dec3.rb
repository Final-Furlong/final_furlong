class ActiveRecordDoctorFixesDec3 < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :race_entries, :odd_id, algorithm: :concurrently, if_not_exists: true
  end
end

