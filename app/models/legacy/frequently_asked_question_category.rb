module Legacy
  class FrequentlyAskedQuestionCategory < Record
    self.table_name = "ff_faq_categories"
  end
end

# == Schema Information
#
# Table name: ff_faq_categories
# Database name: legacy
#
#  id       :integer          unsigned, not null, primary key
#  approved :string(1)        default("Y"), indexed => [parent]
#  category :string(50)       not null
#  parent   :integer          default(0), not null, indexed => [approved]
#
# Indexes
#
#  parent_search  (parent,approved)
#

