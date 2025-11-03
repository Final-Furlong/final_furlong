module Legacy
  class FrequentlyAskedQuestionQuestion < Record
    self.table_name = "ff_faq_questions"
    self.primary_key = "QuestionID"
  end
end

# == Schema Information
#
# Table name: ff_faq_questions
# Database name: legacy
#
#  Email      :string(50)       not null
#  Name       :string(50)       not null, indexed
#  Question   :text(4294967295) not null
#  QuestionID :integer          not null, primary key
#  Respond    :string(1)        default("N"), not null
#
# Indexes
#
#  Name  (Name)
#

