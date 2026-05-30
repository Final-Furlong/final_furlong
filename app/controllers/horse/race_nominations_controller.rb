module Horse
  class RaceNominationsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.includes(:race_options,
        :breeders_cup_nomination,
        :supplemental_breeders_cup_nomination,
        :breeders_cup_sc_sprint_qualification,
        :breeders_cup_sc_classic_qualification,
        :breeders_cup_sc_endurance_qualification).find(params[:id])
      authorize @horse, :view_nominations?, policy_class: CurrentStable::RacehorsePolicy
    end
  end
end

