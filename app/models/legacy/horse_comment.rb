module Legacy
  class HorseComment < Record
    self.table_name = "ff_horse_comments"
    self.primary_key = "ID"

    scope :famous_stud, -> { where(CommentID: 1) }
  end
end

# == Schema Information
#
# Table name: ff_horse_comments
#
#  CommentID :integer          default(0), not null
#  Horse     :integer          not null
#  ID        :integer          not null, primary key
#

