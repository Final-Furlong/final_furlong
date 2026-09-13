module Game
  class EclipseAwardVote < ApplicationRecord
    self.table_name = "eclipse_award_votes"

    belongs_to :contender, class_name: "Game::EclipseAwardContender"
    belongs_to :voter, class_name: "Account::Stable"

    validates :category, presence: true
  end
end

# == Schema Information
#
# Table name: eclipse_award_votes
# Database name: primary
#
#  id           :bigint           not null, primary key
#  category     :enum             not null, uniquely indexed => [voter_id]
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  contender_id :bigint           not null, uniquely indexed => [voter_id]
#  voter_id     :bigint           not null, uniquely indexed => [category], uniquely indexed => [contender_id], indexed
#
# Indexes
#
#  index_eclipse_award_votes_on_category_and_voter_id      (category,voter_id) UNIQUE
#  index_eclipse_award_votes_on_contender_id_and_voter_id  (contender_id,voter_id) UNIQUE
#  index_eclipse_award_votes_on_voter_id                   (voter_id)
#
# Foreign Keys
#
#  fk_rails_...  (contender_id => eclipse_award_contenders.id)
#  fk_rails_...  (voter_id => stables.id)
#

