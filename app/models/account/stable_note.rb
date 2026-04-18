module Account
  class StableNote < ApplicationRecord
    belongs_to :stable

    validates :title, :text, presence: true
    validates :private, inclusion: { in: [true, false] }
    validates :title, length: { in: 3..200 }
    validates :text, length: { in: 3..2_000 }
  end
end

# == Schema Information
#
# Table name: stable_notes
# Database name: primary
#
#  id         :bigint           not null, primary key
#  private    :boolean          default(TRUE), not null, indexed
#  text       :text             indexed
#  title      :string           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stable_id  :bigint           not null, indexed
#
# Indexes
#
#  index_stable_notes_on_private    (private)
#  index_stable_notes_on_stable_id  (stable_id)
#  index_stable_notes_on_text       (text)
#  index_stable_notes_on_title      (title)
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id)
#

