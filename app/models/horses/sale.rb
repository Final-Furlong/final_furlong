module Horses
  class Sale < ApplicationRecord
    self.table_name = "horse_sales"

    belongs_to :horse
    belongs_to :seller, class_name: "Account::Stable"
    belongs_to :buyer, class_name: "Account::Stable"

    validates :date, :price, presence: true
    validates :buyer, comparison: { other_than: :seller }
    validates :private, inclusion: { in: [true, false] }
  end
end

# == Schema Information
#
# Table name: horse_sales
# Database name: primary
#
#  id         :bigint           not null, primary key
#  date       :date             not null, indexed
#  price      :integer          default(0), not null
#  private    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  buyer_id   :bigint           not null, indexed
#  horse_id   :bigint           not null, indexed
#  seller_id  :bigint           not null, indexed
#
# Indexes
#
#  index_horse_sales_on_buyer_id   (buyer_id)
#  index_horse_sales_on_date       (date)
#  index_horse_sales_on_horse_id   (horse_id)
#  index_horse_sales_on_seller_id  (seller_id)
#
# Foreign Keys
#
#  fk_rails_...  (buyer_id => stables.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (seller_id => stables.id)
#

