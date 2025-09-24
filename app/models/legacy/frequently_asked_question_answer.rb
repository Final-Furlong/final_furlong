module Legacy
  class FrequentlyAskedQuestionAnswer < Record
    self.table_name = "ff_faq_answers"
  end
end

# == Schema Information
#
# Table name: ff_faq_answers
#
#  id       :integer          not null, primary key
#  answer   :text(4294967295) not null
#  category :integer          not null
#  order    :integer          default(0), not null
#  question :string(255)      not null
#

