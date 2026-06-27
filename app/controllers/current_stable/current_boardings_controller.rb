module CurrentStable
  class CurrentBoardingsController < ::AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      authorize %i[current_stable boarding], :list_current?

      @query = policy_scope(Horses::Racehorse::Boarding.current, policy_scope_class: CurrentStable::BoardingPolicy::Scope)
      @query = @query.includes(horse: :race_metadata, location: :racetrack).ransack(params[:q])
      @query.sorts = ["horse_race_metadata_energy_grade asc", "horse_name asc"] if @query.sorts.blank?
      @pagy, @boardings = pagy(:countless, @query.result)
    end
  end
end

