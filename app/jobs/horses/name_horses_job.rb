class Horses::NameHorsesJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    result = Horses::AutoNamer.new.call
    store_job_info(outcome: result)
  end
end

