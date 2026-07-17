module CurrentStable
  class BreedersCupNominationsController < AuthenticatedController
    def new
      authorize Current.stable, :nominate_breeders_cup?
    end

    def create
      authorize Current.stable, :nominate_breeders_cup?

      result = Horses::Racehorse::BreedersCupNominator.new.nominate_horses(horse_ids: params[:horse_ids], stable: Current.stable)
      if result.created?
        flash[:success] = t(".success_count", count: result.horses.count)
      else
        flash[:error] = result.error
      end
      remaining_weanlings = Horses::Horse::Foal.weanling.active.managed_by(Current.stable).joins(sire: :nominations).where(sire: { stud_breeders_cup_nominations: { year: Date.current.year } }).where.missing(:breeders_cup_nomination).exists?
      redirect_to remaining_weanlings ? new_stable_breeders_cup_nomination_path : current_stable_path
    end
  end
end

