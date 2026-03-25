module CurrentStable
  class HistoricalBoardingsController < ::AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      authorize %i[current_stable boarding], :list_historical?

      query = policy_scope(Horses::Boarding.ended, policy_scope_class: CurrentStable::BoardingPolicy::Scope)
      query = query.includes(:horse, location: :racetrack).ransack(params[:q])
      query.sorts = ["end_date desc", "start_date desc", "name asc"] if query.sorts.blank?
      @pagy, @boardings = pagy(:offset, query.result)
    end
  end
end

