module Horse
  class EventsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :view_events?, policy_class: CurrentStable::HorsePolicy

      @dashboard = Dashboard::Horse::Events.new(horse:)
    end
  end
end

