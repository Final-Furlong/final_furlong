class AuditSalesJob < ApplicationJob
  queue_as :latency_5m

  def perform
    stable = Account::Stable.find_by(name: "Starfish Stables")
    Horses::Horse.where(id: 57810).update(owner: stable)
    stable = Account::Stable.find_by(name: "Gintara Lodge")
    Horses::Horse.where(id: 57608).update(owner: stable)
    stable = Account::Stable.find_by(name: "Stillwater Farms")
    Horses::Horse.where(id: 57712).update(owner: stable)
    stable = Account::Stable.find_by(name: "AllegroThoroughbreds")
    Horses::Horse.where(id: 58234).update(owner: stable)
    stable = Account::Stable.find_by(name: "Locheido Stables")
    Horses::Horse.where(id: 57605).update(owner: stable)
    stable = Account::Stable.find_by(name: "Final Furlong")
    Horses::Horse.where(id: [58610, 58181, 58350, 58557, 58137]).update(owner: stable)

    transactions = 0
    Horses::Sale.where("date BETWEEN ? AND ?", Date.new(2025, 11, 1), Date.current).find_each do |current_sale|
      sale = Horses::Sale.where(horse: current_sale.horse).order(created_at: :desc).first
      buyer = sale.buyer
      seller = sale.seller
      horse = sale.horse
      price = sale.price.abs
      query = Account::Budget.where(stable: seller, created_at: sale.date.all_day, amount: price, activity_type: "sold_horse")
      query = query.where("description ILIKE ?", "%Sold #{horse.name} to #{buyer.name}")
      if seller.name != Config::Game.stable
        ActiveRecord::Base.transaction do
          if !query.exists?
            previous_budget = Account::Budget.where(stable: seller).where(created_at: ..sale.date.end_of_day).order(created_at: :desc).first
            Account::Budget.create!(stable: seller, created_at: sale.date.end_of_day, amount: price, balance: previous_budget.balance + price, description: "Sold #{horse.name} to #{buyer.name}", activity_type: "sold_horse")
            transactions += 1
            Account::Budget.where(stable: seller).where(created_at: (sale.date + 1.day).beginning_of_day..).find_each do |trans|
              trans.update(balance: trans.balance + price)
            end
            seller.update(available_balance: seller.available_balance + price, total_balance: seller.total_balance + price)
          end
          query2 = Account::Budget.where(stable: seller, created_at: sale.date.all_day, amount: price * -1, activity_type: "bought_horse")
          query2 = query2.where("description ILIKE ?", "%Bought #{horse.name} from %")
          if query2.exists?
            extra_budget = query2.first
            amount = extra_budget.amount * -1
            transactions += 1
            seller.update(available_balance: seller.available_balance + amount, total_balance: seller.total_balance + amount)
            Account::Budget.where(stable: seller).where("id > ?", extra_budget.id).where(created_at: (sale.date + 1.day).beginning_of_day..).find_each do |trans|
              trans.update(balance: trans.balance + amount)
            end
            extra_budget.destroy
          end
        end
      end
      query = Account::Budget.where(stable: buyer, created_at: sale.date.all_day, amount: price * -1, activity_type: "bought_horse")
      query = query.where("description ILIKE ?", "%Bought #{horse.name} from #{seller.name}")
      if buyer.name != Config::Game.stable
        ActiveRecord::Base.transaction do
          if !query.exists?
            transactions += 1
            previous_budget = Account::Budget.where(stable: buyer).where(created_at: ..sale.date.end_of_day).order(created_at: :desc).first
            Account::Budget.create!(stable: buyer, created_at: sale.date.end_of_day, amount: price * -1, balance: previous_budget.balance - price, description: "Purchased #{horse.name} from #{seller.name}", activity_type: "bought_horse")
            Account::Budget.where(stable: buyer).where(created_at: (sale.date + 1.day).beginning_of_day..).find_each do |trans|
              trans.update(balance: trans.balance - price)
            end
            buyer.update(available_balance: buyer.available_balance - price, total_balance: buyer.total_balance - price)
          end
          query2 = Account::Budget.where(stable: buyer, created_at: sale.date.all_day, amount: price, activity_type: "sold_horse")
          query2 = query2.where("description ILIKE ?", "%Sold #{horse.name} to %")
          if query2.exists?
            transactions += 1
            extra_budget = query2.first
            amount = extra_budget.amount * -1
            buyer.update(available_balance: buyer.available_balance + amount, total_balance: seller.total_balance + amount)
            Account::Budget.where(stable: buyer).where("id > ?", extra_budget.id).where(created_at: (sale.date + 1.day).beginning_of_day..).find_each do |trans|
              trans.update(balance: trans.balance + amount)
            end
            extra_budget.destroy
          end
        end
      end
    end

    store_job_info(outcome: { transactions: })
  end
end

