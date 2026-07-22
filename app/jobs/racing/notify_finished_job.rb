class Racing::NotifyFinishedJob < ApplicationJob
  queue_as :latency_30s

  def perform(batch, _context)
    require "rake"
    FinalFurlong::Application.load_tasks
    system "bundle exec rake maintenance:end"
    User::SendDeveloperNotifications.call(title: "FF Races Finished", message: "Races finished running for #{batch.properties[:date]}!")
  end
end

