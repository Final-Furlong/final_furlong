module Racing
  class BreedersCupQualifiersController < AuthenticatedController
    def index
      @races = policy_scope(Racing::RaceSchedule.breeders_cup.current_year.order(name: :asc))
    end

    def show
      @race = Racing::RaceSchedule.breeders_cup.current_year.find(params[:id])
      authorize @race, :view_qualifiers?
    end
  end
end

