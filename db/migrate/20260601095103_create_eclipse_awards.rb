class CreateEclipseAwards < ActiveRecord::Migration[8.1]
  def change
    categories = %w[
      2yo_colt 2yo_filly 3yo_colt 3yo_filly
      older_horse older_mare sprinter
      classic endurance turf_horse
      turf_mare sc_colt sc_filly
      sc_horse sc_mare horse
      stable breeder sire
    ]
    create_enum :eclipse_award_categories, categories

    create_table :eclipse_awards do |t|
      t.references :awardable, polymorphic: true
      t.integer :year, default: 0, null: false, index: true
      t.enum :category, enum_type: :eclipse_award_categories, comment: categories.join(",")

      t.timestamps
    end

    add_index :eclipse_awards, %i[awardable_type awardable_id]
    add_index :eclipse_awards, %i[awardable_type awardable_id year]
    add_index :eclipse_awards, %i[year category]
  end
end

