class AddTieBreakerToEclipseVote < ActiveRecord::Migration[8.1]
  def change
    add_column :eclipse_award_contenders, :tie_breaker, :boolean, default: false, null: false

    add_index :eclipse_award_contenders, :tie_breaker
  end
end

