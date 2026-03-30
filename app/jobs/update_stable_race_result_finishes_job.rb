class UpdateStableRaceResultFinishesJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    step :process do |step|
      Racing::RaceResultHorse.where(stable_id: nil).find_each(start: step.cursor) do |rr_horse|
        horse = rr_horse.horse

        stable = find_stable(horse, rr_horse.race.date, rr_horse.race.number)
        rr_horse.update(stable:) if stable
        step.advance! from: rr_horse.id
      end
    end
  end

  private

  def find_stable(horse, date, number)
    date_string = if date < Date.new(2004, 1, 1)
      (date + 4.years).strftime("%B %Y")
    else
      date + 4.years
    end
    description = "Entry Fee: #{date_string}, Race #{number} - #{horse.name}"
    budget = Account::Budget.find_by(description:)
    return budget.stable if budget

    if (lease = horse.current_lease)
      return lease.leaser if date.between?(lease.start_date, lease.end_date)
    end

    lease = horse.past_leases.find_by("start_date <= ? AND end_date >= ?", date, date)
    return lease.leaser if lease

    sale = horse.sales.where(date: ..date).order(date: :desc).first
    return sale.buyer if sale

    horse.owner
  end
end

