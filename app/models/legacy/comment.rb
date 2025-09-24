module Legacy
  class Comment < Record
    self.table_name = "ff_comment"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_budgets
#
#  Amount      :integer
#  Balance     :integer
#  Date        :date             indexed, indexed => [Stable, Description]
#  Description :string(255)      indexed, indexed => [Stable, Date], indexed => [Stable]
#  ID          :integer          not null, primary key
#  Stable      :integer          indexed, indexed => [Date, Description], indexed => [Description]
#
# Indexes
#
#  Date                     (Date)
#  Stable                   (Stable)
#  description              (Description)
#  stable_date_description  (Stable,Date,Description)
#  stable_description       (Stable,Description)
#

