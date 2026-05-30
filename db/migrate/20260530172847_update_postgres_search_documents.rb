class UpdatePostgresSearchDocuments < ActiveRecord::Migration[8.1]
  def change
    change_column_null :pg_search_documents, :searchable_type, false
    change_column_null :pg_search_documents, :searchable_id, false

    remove_index :pg_search_documents, %i[searchable_type searchable_id], if_exists: true
    add_index :pg_search_documents, %i[searchable_type searchable_id], unique: true
  end
end

