module Legacy
  class FrequentlyAskedQuestionArticle < Record
    self.table_name = "ff_faq_articles"
    self.primary_key = "FileID"
  end
end

# == Schema Information
#
# Table name: ff_faq_articles
#
#  Approved    :string(1)        default("N")
#  Articledata :text(4294967295)
#  AuthorID    :integer          default(0), unsigned, not null
#  CatID       :integer          default(0), unsigned, not null
#  Category    :string(50)
#  FileID      :integer          unsigned, not null, primary key
#  Keywords    :string(80)       indexed
#  ParentID    :integer          default(0), unsigned, not null
#  RatedTotal  :string(5)        default("0"), not null
#  RatingTotal :string(5)        default("0"), not null
#  SubmitDate  :datetime         not null
#  Title       :string(50)       not null
#  Views       :integer          default(0)
#
# Indexes
#
#  Keywords  (Keywords)
#

