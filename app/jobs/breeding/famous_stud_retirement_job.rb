class Breeding::FamousStudRetirementJob < ApplicationJob
  queue_as :latency_30s

  def perform
    User::SendDeveloperNotifications.call(title: "Retire Famous Studs", message: "It's time to check famous studs for retirement.")
  end
end

