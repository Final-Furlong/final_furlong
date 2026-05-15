class Racing::BreedersCupSelectionJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  def perform
    bc_race = Racing::RaceSchedule.breeders_cup.current_year.first
    return unless bc_race
    deadline = bc_race.entry_open_date - Config::Racing.breeders_cup_nomination_deadline_days.days
    return unless Date.current == deadline

    horses = 0
    races = 0

    step :process do
      Racing::RaceSchedule.breeders_cup.current_year.find_each(start: step.cursor) do |race|
        next if Racing::BreedersCupPotentialEntry.exists?(race:)

        result = Racing::BreedersCupEntrySelector.new.select_horses(race:)
        horses += result.horses
        races += 1

        step.advance! from: race.id
      end
    end
    store_job_info(outcome: { horses:, races: })
  end
end

