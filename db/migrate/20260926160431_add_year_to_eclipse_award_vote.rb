class AddYearToEclipseAwardVote < ActiveRecord::Migration[8.1]
  def change
    add_column :eclipse_award_votes, :year, :integer, default: 0, null: false

    remove_index :eclipse_award_votes, %i[category voter_id], if_exists: true
    add_index :eclipse_award_votes, %i[category year voter_id], unique: true
  end
end

