FactoryBot.define do
  factory :stud_foal_record, class: "Horses::StudFoalRecord" do
    stud { association :horse, :stallion }
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
# Table name: stud_foal_records
# Database name: primary
#
#  id                               :bigint           not null, primary key
#  born_foals_count                 :integer          default(0), not null, indexed
#  breed_ranking                    :string
#  crops_count                      :integer          default(0), not null
#  millionaire_foals_count          :integer          default(0), not null
#  multi_millionaire_foals_count    :integer          default(0), not null
#  multi_stakes_winning_foals_count :integer          default(0), not null
#  raced_foals_count                :integer          default(0), not null
#  stakes_winning_foals_count       :integer          default(0), not null
#  stillborn_foals_count            :integer          default(0), not null
#  total_foal_earnings              :bigint           default(0), not null
#  total_foal_points                :integer          default(0), not null
#  total_foal_races                 :integer          default(0), not null
#  unborn_foals_count               :integer          default(0), not null
#  winning_foals_count              :integer          default(0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  horse_id                         :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_stud_foal_records_on_born_foals_count  (born_foals_count)
#  index_stud_foal_records_on_horse_id          (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

