module CurrentStable
  class RecentFoalsController < AuthenticatedController
    def index
      @query = policy_scope(Horses::Horse, policy_scope_class: CurrentStable::HorsePolicy::Scope)
      @date = Date.parse(params[:date])
      @query = if @date
        if params[:this_date]
          @query.where(date_of_birth: @date)
        else
          @query.where("date_of_birth BETWEEN ? AND ?", @date, Date.current)
        end
      else
        @query.where(date_of_birth: ..Date.current)
      end
      @query = @query.includes(:breeder, :appearance, sire: :stud_foal_record, dam: [:broodmare_foal_record, :sire])

      @pagy, @foals = pagy(:countless, @query)
    end
  end
end

