class CreateEclipseAwardVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :eclipse_award_votes do |t|
      t.references :contender, type: :bigint, null: false, index: false, foreign_key: { to_table: :eclipse_award_contenders }
      t.references :voter, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.enum :category, enum_type: :eclipse_award_categories, null: false, index: false

      t.timestamps
    end

    add_index :eclipse_award_votes, %i[contender_id voter_id], unique: true
    add_index :eclipse_award_votes, %i[category voter_id], unique: true
  end
end

