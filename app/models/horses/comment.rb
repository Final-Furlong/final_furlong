module Horses
  class Comment < ApplicationRecord
    self.table_name = "horse_comments"

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :stable, class_name: "Account::Stable"

    scope :visible_by_owner, -> { where(private: [true, false]) }
    scope :visible_by_all, -> { where(private: false) }

    validates :comment, presence: true
    validates :private, inclusion: { in: [true, false] }
  end
end

# == Schema Information
#
# Table name: horse_comments
# Database name: primary
#
#  id         :bigint           not null, primary key
#  comment    :text             not null
#  private    :boolean          default(TRUE), not null, indexed
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, indexed
#  stable_id  :bigint           not null, indexed
#
# Indexes
#
#  index_horse_comments_on_horse_id   (horse_id)
#  index_horse_comments_on_private    (private)
#  index_horse_comments_on_stable_id  (stable_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (stable_id => stables.id)
#

