# frozen_string_literal: true

class UpdateBudgetDescriptions < ActiveRecord::Migration[8.1]
  def up
    statements = [
      "UPDATE budget_transactions SET activity_type = 'entered_race' WHERE activity_type IS NULL AND description LIKE 'Entry Fee%'",
      "UPDATE budget_transactions SET activity_type = 'race_winnings' WHERE activity_type IS NULL AND description LIKE 'Race Winnings%'",
      "UPDATE budget_transactions SET activity_type = 'jockey_fee' WHERE activity_type IS NULL AND description LIKE 'Jockey Fee: %'",
      "UPDATE budget_transactions SET activity_type = 'bred_stud' WHERE activity_type IS NULL AND description LIKE 'Stud Booking%'",
      "UPDATE budget_transactions SET activity_type = 'bred_mare' WHERE activity_type IS NULL AND description LIKE 'Breeding: %'",
      "UPDATE budget_transactions SET activity_type = 'sold_horse' WHERE activity_type IS NULL AND description LIKE 'Sold %'",
      "UPDATE budget_transactions SET activity_type = 'sold_horse' WHERE activity_type IS NULL AND description LIKE '% Auction%' AND description LIKE '%: Sold %'",
      "UPDATE budget_transactions SET activity_type = 'bought_horse' WHERE activity_type IS NULL AND description LIKE 'Purchased %'",
      "UPDATE budget_transactions SET activity_type = 'bought_horse' WHERE activity_type IS NULL AND description LIKE '% Auction%' AND description LIKE '%: Purchased %'",
      "UPDATE budget_transactions SET activity_type = 'bought_horse' WHERE activity_type IS NULL AND description LIKE 'Adoption Agency %'",
      "UPDATE budget_transactions SET activity_type = 'claimed_horse' WHERE activity_type IS NULL AND (description LIKE 'Claim: %' OR description LIKE 'Claimed: %')",
      "UPDATE budget_transactions SET activity_type = 'nominated_racehorse' WHERE activity_type IS NULL AND description LIKE 'Race Nomination: %'",
      "UPDATE budget_transactions SET activity_type = 'nominated_racehorse' WHERE activity_type IS NULL AND description LIKE 'Late Breeders'' Cup Nomination: %'",
      "UPDATE budget_transactions SET activity_type = 'nominated_racehorse' WHERE activity_type IS NULL AND description LIKE 'Supplemental Nomination: %'",
      "UPDATE budget_transactions SET activity_type = 'nominated_stallion' WHERE activity_type IS NULL AND description LIKE 'Breeders'' Cup Stallion Nomination: %'",
      "UPDATE budget_transactions SET activity_type = 'shipped_horse' WHERE activity_type IS NULL AND description LIKE 'Shipped %'",
      "UPDATE budget_transactions SET activity_type = 'opening_balance' WHERE activity_type IS NULL AND description LIKE 'Opening Balance'",
      "UPDATE budget_transactions SET activity_type = 'paid_tax' WHERE activity_type IS NULL AND
                                                                    (description LIKE '% Racehorse Tax' OR description LIKE '% Broodmare Tax' OR
                                                                     description LIKE '% Stallion Tax' OR description LIKE '% Yearling/Weanling Tax' OR
                                                                     description LIKE '% Sales Tax' OR description LIKE '% Stable Tax')",
      "UPDATE budget_transactions SET activity_type = 'nominated_breeders_series' WHERE activity_type IS NULL AND description LIKE '% Breeders'' Series Nomination: %'",
      "UPDATE budget_transactions SET activity_type = 'handicapping_races' WHERE activity_type IS NULL AND description LIKE 'Handicapping %'",
      "UPDATE budget_transactions SET activity_type = 'handicapping_races' WHERE activity_type IS NULL AND description LIKE '% Handicapping Races: %'",
      "UPDATE budget_transactions SET activity_type = 'handicapping_races' WHERE activity_type IS NULL AND description LIKE '% Handicapping: %'",
      "UPDATE budget_transactions SET activity_type = 'consigned_auction' WHERE activity_type IS NULL AND description LIKE 'Consigned %' AND description LIKE '% Auction'",
      "UPDATE budget_transactions SET activity_type = 'consigned_auction' WHERE activity_type IS NULL AND description LIKE 'Consigning %' AND description LIKE '% Auction'",
      "UPDATE budget_transactions SET activity_type = 'leased_horse' WHERE activity_type IS NULL AND description LIKE 'Leased %' AND description LIKE '% to %'",
      "UPDATE budget_transactions SET activity_type = 'leased_horse' WHERE activity_type IS NULL AND description LIKE 'Lease Fee: %'",
      "UPDATE budget_transactions SET activity_type = 'leased_horse' WHERE activity_type IS NULL AND description LIKE 'Lease Refund: %'",
      "UPDATE budget_transactions SET activity_type = 'leased_horse' WHERE activity_type IS NULL AND description LIKE 'Lease Terminated: %'",
      "UPDATE budget_transactions SET activity_type = 'boarded_horse' WHERE activity_type IS NULL AND description LIKE 'Board for %'",
      "UPDATE budget_transactions SET activity_type = 'color_war' WHERE activity_type IS NULL AND
         (description LIKE '% Color War %' OR description LIKE '% Color War: %' OR description LIKE '% Color War')",
      "UPDATE budget_transactions SET activity_type = 'activity_points' WHERE activity_type IS NULL AND
         ((description LIKE 'Redeemed %' AND description LIKE '% Activity Points') OR description LIKE 'Redeemed Activity Points: %')",
      "UPDATE budget_transactions SET activity_type = 'donation' WHERE activity_type IS NULL AND
         (description LIKE '% for donating to Final %' OR description LIKE '% for donation to Final %' OR
         description LIKE '% your donation to Final %' OR description LIKE '% your donation towards Final %' OR
         description LIKE 'Thanks for your donation to %' OR description = 'Thanks for your donation!' OR
         description LIKE 'Thanks for your generous donation %' OR description LIKE 'Thank you for your generous donation %')",
      "UPDATE budget_transactions SET activity_type = 'won_breeders_series' WHERE activity_type IS NULL AND
         description LIKE '% Breeders'' Series%' AND description LIKE '%Winner%'",
      "UPDATE budget_transactions SET activity_type = 'misc' WHERE activity_type IS NULL"
    ]
    statements.each do |sql|
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

