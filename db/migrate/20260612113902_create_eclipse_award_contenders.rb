class CreateEclipseAwardContenders < ActiveRecord::Migration[8.1]
  def change
    categories = %w[
      2yo_colt 2yo_filly 3yo_colt 3yo_filly
      older_horse older_mare sprinter
      classic endurance turf_horse
      turf_mare sc_colt sc_filly
      sc_horse sc_mare horse
      stable breeder sire
    ]
    create_table :eclipse_award_contenders do |t|
      t.references :awardable, polymorphic: true, index: false
      t.integer :year, default: 0, null: false
      t.enum :category, enum_type: :eclipse_award_categories, null: false, comment: categories.join(",")
      t.datetime :voting_starts_at, null: false, index: true
      t.datetime :voting_ends_at, null: false, index: true

      t.timestamps
    end

    change_column_null :eclipse_award_contenders, :awardable_type, false
    change_column_null :eclipse_award_contenders, :awardable_id, false

    add_index :eclipse_award_contenders, %i[awardable_type category awardable_id], unique: true
    add_index :eclipse_award_contenders, %i[awardable_type awardable_id year]
    add_index :eclipse_award_contenders, %i[year category]
  end
end
