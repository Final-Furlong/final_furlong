module Legacy
  class DeletedStable < Record
    self.table_name = "ff_deleted_stables"
  end
end

# == Schema Information
#
# Table name: ff_deleted_stables
#
#  id      :integer          not null, primary key
#  balance :integer          not null
#  date    :date             not null
#  horses  :text(65535)      not null
#

