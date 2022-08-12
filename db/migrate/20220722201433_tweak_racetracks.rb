class TweakRacetracks < ActiveRecord::Migration[7.0]
  def up
    change_column_null :racetracks, :state, true

    change_column :users, :email, :string, default: "", null: false, index: { unique: true }

    change_column_null :users, :created_at, false
    change_column_null :users, :updated_at, false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

