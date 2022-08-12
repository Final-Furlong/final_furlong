class CreateRacetracks < ActiveRecord::Migration[7.0]
  def change
    create_table :racetracks do |t|
      t.string :name, index: { unique: true }
      t.string :state
      t.string :country, index: true
      t.decimal :latitude, index: true
      t.decimal :longitude, index: true

      t.timestamps
    end
  end
end

