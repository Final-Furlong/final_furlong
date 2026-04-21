module Racing
  class ClaimsProcessor
    def process_claims(date:)
      claims = 0
      Racing::RaceSchedule.where(date:, race_type: "claiming").find_each do |race|
        race.entries.where.associated(:claims).distinct.find_each do |entry|
          process_claim(entry:)
        end
        claims += 1
      end
      claims
    end

    private

    def process_claim(entry:)
      race = entry.race
      claim_price = race.claiming_price
      horse = entry.horse
      claimed = false
      until claimed || entry.claims.count == 0
        winning_claim = entry.claims.order("RANDOM()").first
        owner = winning_claim.owner
        claimer = winning_claim.claimer

        if claimer.available_balance.to_i > claim_price
          ActiveRecord::Base.transaction do
            horse.update(owner: claimer)
            if (auction_horse = horse.auction_horse)
              auction_horse.destroy if auction_horse.auction.future?
            end
            horse.training_schedules_horse&.destroy
            description = "Claimed: #{horse.name} from race #{entry.race.number}"
            Accounts::BudgetTransactionCreator.new.create_transaction(stable: owner, description:, amount: claim_price)
            description = "Claim: #{horse.name} from race #{entry.race.number}"
            Accounts::BudgetTransactionCreator.new.create_transaction(stable: claimer, description:, amount: claim_price * -1)
            Horses::Sale.create!(date: race.date, price: claim_price, private: false, buyer: claimer, seller: owner, horse:)
            entry.claims.map(&:destroy)
          end
          if horse.reload.owner == claimer
            Legacy::Horse.transaction do
              Legacy::Horse.where(ID: horse.legacy_id).update(Owner: claimer.legacy_id)
            end
            claimed = true
          end
        else
          winning_claim.destroy
        end
      end
    end
  end
end

