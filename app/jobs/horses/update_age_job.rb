class Horses::UpdateAgeJob < ApplicationJob
  queue_as :latency_30s

  good_job_concurrency_rule(
    label: -> { arguments.first[:id] },
    total_limit: 1
  )

  def perform(id:)
    horse = Horses::Horse.find(id)
    max_year = horse.deceased? ? horse.date_of_death.year : Date.current.year
    horse.update(age: max_year - horse.date_of_birth.year)
  end
end

