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
#  average_earnings                 :decimal(, )
#  born_foals_count                 :integer
#  breed_ranking                    :text
#  breed_ranking_points             :decimal(, )
#  millionaire_foals_count          :integer
#  multi_millionaire_foals_count    :integer
#  multi_stakes_winning_foals_count :integer
#  next_due_date                    :date
#  raced_foals_count                :integer
#  stakes_winning_foals_count       :integer
#  stillborn_foals_count            :integer
#  total_foal_earnings              :bigint
#  total_foal_points                :integer
#  total_foal_races                 :integer
#  unborn_foals_count               :integer
#  winning_foals_count              :integer
#  horse_id                         :bigint
#  in_foal_stud_id                  :bigint
#

