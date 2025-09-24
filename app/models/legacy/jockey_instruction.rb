module Legacy
  class JockeyInstruction < Record
    self.table_name = "ff_jockey_instructions"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_jockey_instructions
#
#  ID           :integer          not null, primary key
#  Instructions :string(255)      not null
#  Text         :string(255)      not null
#

