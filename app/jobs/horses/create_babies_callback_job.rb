class Horses::CreateBabiesCallbackJob < ApplicationJob
  queue_as :latency_30s

  def perform(batch, _context)
    starting_count = batch.properties[:starting_foal_count]
    ending_count = Horses::Breeding.where(status: "bred", year: Date.current.year).where.associated(:first_foal).count
    foal_count = ending_count - starting_count

    result = Horses::Breeding.where(status: "bred", year: Date.current.year).group(:event).count
    result[:new_babies] = foal_count
    User::SendDeveloperNotifications.call(title: "FF Foals Created", message: "#{foal_count} foal(s) created!")

    store_job_info(outcome: result, class_name: "Horses::CreateBabiesJob")
  end
end

