module Accounts
  class BudgetTransactionCreator < ApplicationService
    def create_transaction(stable:, description:, amount:, date: nil, legacy_budget_id: nil, activity_type: nil)
      previous_budget = Account::Budget.where(stable:).recent.first
      attrs = {
        stable:,
        description:,
        amount:,
        balance: (previous_budget&.balance || 0) + amount,
        legacy_stable_id: stable.legacy_id,
        activity_type: activity_type(description)
      }
      attrs[:created_at] = date if date.present?
      attrs[:legacy_budget_id] = legacy_budget_id if legacy_budget_id.present?
      ActiveRecord::Base.transaction do
        new_budget = Account::Budget.create!(attrs)
        stable.total_balance += amount
        stable.available_balance += amount
        stable.save!

        Accounts::ActivityTransactionCreator.new.create_transaction(stable:, activity_type:, budget: new_budget) if activity_type

        new_budget
      end
    end

    private

    def activity_type(description)
      if description.starts_with?("Entry Fee:")
        "entered_race"
      elsif description.starts_with?("Race Winnings:")
        "race_winnings"
      elsif description.starts_with?("Jockey Fee:")
        "jockey_fee"
      elsif description.starts_with?("Stud Booking")
        "bred_stud"
      elsif description.starts_with?("Breeding: ")
        "bred_mare"
      elsif sale_entry?(description)
        "sold_horse"
      elsif purchase_entry?(description)
        "bought_horse"
      elsif description.starts_with?("Claim: ") || description.starts_with?("Claimed: ")
        "claimed_horse"
      elsif nomination_racehorse_entry?(description)
        "nominated_racehorse"
      elsif description.starts_with?("Breeders' Cup Stallion Nomination: ")
        "nominated_stallion"
      elsif description.starts_with?("Shipped ")
        "shipped_horse"
      elsif description == "Opening Balance"
        "opening_balance"
      elsif tax_entry?(description)
        "paid_tax"
      elsif description.include?(" Breeders' Series Nomination: ")
        "nominated_breeders_series"
      elsif handicapping_entry?(description)
        "handicapping_races"
      elsif consigning_entry?(description)
        "consigned_auction"
      elsif leased_entry?(description)
        "leased_horse"
      elsif description.starts_with?("Board for ")
        "boarded_horse"
      elsif color_war_entry?(description)
        "leased_horse"
      elsif activity_entry?(description)
        "activity_points"
      elsif donation_entry?(description)
        "donation"
      elsif description.include?(" Breeders' Series") && description.include?("Winner")
        "won_breeders_series"
      else
        "misc"
      end
    end

    def sale_entry?(value)
      return true if value.starts_with?("Sold ")

      value.include?(" Auction") && value.include?(": Sold")
    end

    def purchase_entry?(value)
      return true if value.starts_with?("Purchased ")
      return true if value.starts_with?("Adoption Agency ")

      value.include?(" Auction") && value.include?(": Purchased")
    end

    def nomination_racehorse_entry?(value)
      return true if value.starts_with?("Race Nomination: ")
      return true if value.starts_with?("Late Breeders' Cup Nomination: ")

      value.starts_with?("Supplemental Nomination: ")
    end

    def tax_entry?(value)
      return true if value.ends_with?(" Racehorse Tax")
      return true if value.ends_with?(" Broodmare Tax")
      return true if value.ends_with?(" Stallion Tax")
      return true if value.ends_with?(" Yearling/Weanling Tax")
      return true if value.ends_with?(" Sales Tax")

      value.ends_with?(" Stable Tax")
    end

    def handicapping_entry?(value)
      return true if value.starts_with?("Handicapping ")
      return true if value.include?(" Handicapping Races:")

      value.include?(" Handicapping: ")
    end

    def consigning_entry?(value)
      return false unless value.ends_with?(" Auction")
      return true if value.starts_with?("Consigned ")

      value.starts_with?("Consigning ")
    end

    def leased_entry?(value)
      return true if value.starts_with?("Lease Fee: ")
      return true if value.starts_with?("Lease Refund: ")
      return true if value.starts_with?("Lease Terminated: ")

      value.starts_with?("Leased ") && value.include?(" to ")
    end

    def color_war_entry?(value)
      return true if value.ends_with?(" Color War")

      value.include?(" Color War: ") || value.include?(" Color War ")
    end

    def activity_entry?(value)
      return true if value.starts_with?("Redeemed Activity Points: ")

      value.starts_with?("Redeemed ") && value.ends_with?(" Activity Points")
    end

    def donation_entry?(value)
      return true if value.starts_with?("Thanks for your donation to ")
      return true if value.starts_with?("Thanks for your donation!")
      return true if value.starts_with?("Thanks for your generous donation ")
      return true if value.starts_with?("Thank you for your generous donation ")
      return true if value.include?(" for donating to Final ")
      return true if value.include?(" for donation to Final ")
      return true if value.include?(" your donation to Final ")

      value.include?(" your donation towards Final ")
    end
  end
end

