module Horse
  class RaceNominationsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.includes(:race_options,
        :breeder,
        :breeders_cup_nomination,
        :supplemental_breeders_cup_nomination,
        :breeders_cup_juvenile_qualification,
        :breeders_cup_juvenile_fillies_qualification,
        :breeders_cup_juvenile_turf_qualification,
        :breeders_cup_juvenile_turf_fillies_qualification,
        :breeders_cup_sprint_qualification,
        :breeders_cup_turf_sprint_qualification,
        :breeders_cup_mile_qualification,
        :breeders_cup_dirt_mile_qualification,
        :breeders_cup_turf_qualification,
        :breeders_cup_classic_qualification,
        :breeders_cup_filly_and_mare_sprint_qualification,
        :breeders_cup_filly_and_mare_turf_qualification,
        :breeders_cup_distaff_qualification,
        :breeders_cup_sc_sprint_qualification,
        :breeders_cup_sc_classic_qualification,
        :breeders_cup_sc_endurance_qualification,
        :breeders_cup_sc_distaff_qualification,
        :breeders_cup_sc_distaff_endurance_qualification,
        :breeders_cup_sc_sprint_qualification,
        :breeders_cup_sc_classic_qualification,
        :breeders_cup_sc_endurance_qualification).find(params[:id])
      authorize @horse, :view_nominations?, policy_class: CurrentStable::RacehorsePolicy
    end
  end
end
