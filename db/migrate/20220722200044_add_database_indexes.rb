class AddDatabaseIndexes < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    add_index :horses, :date_of_birth unless index_exists?(:horses, :date_of_birth)
    add_index :horses, :status unless index_exists?(:horses, :status)

    add_index :racetracks, :name unless index_exists?(:racetracks, :name)
    add_index :racetracks, :country unless index_exists?(:racetracks, :country)
    add_index :racetracks, :latitude unless index_exists?(:racetracks, :longitude)
    add_index :racetracks, :longitude unless index_exists?(:racetracks, :latitude)

    add_index :stables, :legacy_id unless index_exists?(:stables, :legacy_id)

    rename_column :users, :new_username, :username
    add_index :users, :confirmation_token unless index_exists?(:users, :confirmation_token)
    add_index :users, :discarded_at unless index_exists?(:users, :discarded_at)
    add_index :users, :email unless index_exists?(:users, :email)
    add_index :users, :reset_password_token unless index_exists?(:users, :reset_password_token)
    add_index :users, :username unless index_exists?(:users, :username)
    add_index :users, :unlock_token unless index_exists?(:users, :unlock_token)
    add_index :users, :discourse_id unless index_exists?(:users, :discourse_id)
  end
end

