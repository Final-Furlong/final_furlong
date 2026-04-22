FactoryBot.define do
  factory :broodmare_foal_record, class: "Horses::BroodmareFoalRecord" do
    mare { association :horse, :broodmare }
    born_foals_count { 1 }

    trait :bronze do
      breed_ranking { "bronze" }
    end

    trait :silver do
      breed_ranking { "silver" }
    end

    trait :gold do
      breed_ranking { "gold" }
    end

    trait :platinum do
      breed_ranking { "platinum" }
    end
  end
end

# == Schema Information
#
# Table name: broodmare_foal_records
# Database name: primary
#
#  id                               :bigint           not null, primary key
#  born_foals_count                 :integer          default(0), not null, indexed
#  breed_ranking                    :string           indexed
#  millionaire_foals_count          :integer          default(0), not null, indexed
#  multi_millionaire_foals_count    :integer          default(0), not null, indexed
#  multi_stakes_winning_foals_count :integer          default(0), not null, indexed
#  raced_foals_count                :integer          default(0), not null, indexed
#  stakes_winning_foals_count       :integer          default(0), not null, indexed
#  stillborn_foals_count            :integer          default(0), not null, indexed
#  total_foal_earnings              :bigint           default(0), not null
#  total_foal_points                :integer          default(0), not null, indexed
#  total_foal_races                 :integer          default(0), not null, indexed
#  unborn_foals_count               :integer          default(0), not null, indexed
#  winning_foals_count              :integer          default(0), not null, indexed
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  horse_id                         :bigint           not null, uniquely indexed
#
# Indexes
#
#  idx_on_multi_stakes_winning_foals_count_d86a3500a8             (multi_stakes_winning_foals_count)
#  index_broodmare_foal_records_on_born_foals_count               (born_foals_count)
#  index_broodmare_foal_records_on_breed_ranking                  (breed_ranking)
#  index_broodmare_foal_records_on_horse_id                       (horse_id) UNIQUE
#  index_broodmare_foal_records_on_millionaire_foals_count        (millionaire_foals_count)
#  index_broodmare_foal_records_on_multi_millionaire_foals_count  (multi_millionaire_foals_count)
#  index_broodmare_foal_records_on_raced_foals_count              (raced_foals_count)
#  index_broodmare_foal_records_on_stakes_winning_foals_count     (stakes_winning_foals_count)
#  index_broodmare_foal_records_on_stillborn_foals_count          (stillborn_foals_count)
#  index_broodmare_foal_records_on_total_foal_points              (total_foal_points)
#  index_broodmare_foal_records_on_total_foal_races               (total_foal_races)
#  index_broodmare_foal_records_on_unborn_foals_count             (unborn_foals_count)
#  index_broodmare_foal_records_on_winning_foals_count            (winning_foals_count)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

