module Racing
  class ScheduledEntriesController < AuthenticatedController
    def index
      @race = Racing::RaceSchedule.find(params[:race_id])
      @entries = policy_scope(Racing::FutureRaceEntry.where(race: @race), policy_scope_class: CurrentStable::FutureRaceEntryPolicy::Scope)
    end
  end
end

