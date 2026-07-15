class Racing::NotifyFinishedJob < ApplicationJob
  queue_as :latency_30s

  def perform(batch, _context)
    User::SendDeveloperNotifications.call(title: "FF Races Finished", message: "Races finished running for #{batch.properties[:date]}!")
  end
end

