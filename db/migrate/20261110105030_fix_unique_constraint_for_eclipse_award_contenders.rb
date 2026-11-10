class FixUniqueConstraintForEclipseAwardContenders < ActiveRecord::Migration[8.1]
  def change
    remove_index :eclipse_award_contenders, %i[awardable_type category awardable_id], if_exists: true
    add_index :eclipse_award_contenders, %i[awardable_type category awardable_id year], unique: true
  end
end

