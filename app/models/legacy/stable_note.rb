module Legacy
  class StableNote < Record
    self.table_name = "ff_stable_notes"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_stable_notes
#
#  Created :datetime         not null, uniquely indexed => [Stable, Title]
#  ID      :integer          not null, primary key
#  Private :boolean          not null
#  Stable  :integer          not null, uniquely indexed => [Created, Title]
#  Text    :text(4294967295)
#  Title   :string(255)      not null, uniquely indexed => [Stable, Created]
#
# Indexes
#
#  Stable  (Stable,Created,Title) UNIQUE
#

