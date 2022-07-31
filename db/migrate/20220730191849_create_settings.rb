class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings, id: :uuid do |t|
      t.string :theme
      t.string :locale
      t.references :user, type: :uuid, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end
end
