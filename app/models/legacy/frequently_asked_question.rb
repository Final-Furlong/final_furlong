module Legacy
  class FrequentlyAskedQuestion < Record
    self.table_name = "ff_faq"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_faq
# Database name: legacy
#
#  Answer   :text(4294967295) not null
#  Category :integer          default(0), not null
#  ID       :integer          not null, primary key
#  Question :text(65535)      not null
#

