class Racing::BreedersCup::SelectionJob < ApplicationJob
  queue_as :latency_5m

  def perform(id:)
    race = Racing::RaceSchedule.breeders_cup.current_year.find_by(id:)
    return unless race
    deadline = race.entry_open_date - Config::Racing.breeders_cup_nomination_deadline_days.days
    return unless Date.current == deadline

    horses = 0

    return if Racing::BreedersCupPotentialEntry.exists?(race:)

    result = Racing::BreedersCupEntrySelector.new.select_horses(race:)
    horses + result.horses
  end
end
