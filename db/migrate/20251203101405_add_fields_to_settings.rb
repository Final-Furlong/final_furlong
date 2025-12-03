class AddFieldsToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :time_zone, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_column :settings, :website, :jsonb, default: {}
    add_column :settings, :racing, :jsonb, default: {}
  end
end

