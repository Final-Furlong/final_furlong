module Legacy
  class ColorWarSecret < Record
    self.table_name = "ff_cw_secrets"
    self.primary_key = "member_id"
  end
end

# == Schema Information
#
# Table name: ff_cw_secrets
# Database name: legacy
#
#  active     :boolean          not null
#  guessed    :boolean          not null
#  secret     :text(16777215)   not null
#  guesser_id :integer          not null
#  member_id  :integer          not null, primary key
#

