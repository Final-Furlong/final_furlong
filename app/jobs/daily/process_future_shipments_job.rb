class Daily::ProcessFutureShipmentsJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :latency_2m

  good_job_concurrency_rule(
    label: -> { arguments.first[:date] },
    total_limit: 2,
    perform_throttle: [1, 5.minutes],
    key: -> { self.class.name }
  )

  def perform(date: Date.current)
    batch = GoodJob::Batch.new
    unless run_today?
      broodmare_count = 0
      Horses::Broodmare::Shipment.scheduled.where(departure_date: date).find_each do |shipment|
        batch.add(Horses::FutureBroodmareShipmentJob.perform_later(id: shipment.id, date:))
        broodmare_count += 1
      end
    end

    racehorse_count = 0
    Horses::Racehorse::Shipment.scheduled.where(departure_date: date).find_each do |shipment|
      batch.add(Horses::FutureBroodmareShipmentJob.perform_later(id: shipment.id, date:))
      racehorse_count += 1
    end

    Racing::FutureRaceEntry.where(ship_date: date, ship_only_if_horse_is_entered: false).find_each do |entry|
      batch.add(Horses::FutureRaceEntryShipmentJob.perform_later(id: entry.id, date:))
      racehorse_count += 1
    end

    weekday = date.strftime("%A").downcase
    if %w[tuesday friday].include?(weekday)
      Racing::FutureRaceEntry.where(ship_when_entries_open: true, ship_only_if_horse_is_entered: false).find_each do |entry|
        batch.add(Horses::FutureRaceEntryShipmentJob.perform_later(id: entry.id, date:))
        racehorse_count += 1
      end
    end
    batch.enqueue
    outcome = { scheduled: true, broodmare_count:, racehorse_count: }
    store_job_info(outcome:)
  end
end

