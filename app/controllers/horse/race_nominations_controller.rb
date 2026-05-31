module Horse
  class RaceNominationsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_nominations?, policy_class: CurrentStable::RacehorsePolicy
    end
  end
end

