module Horse
  class ShipmentsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :view_shipping?, policy_class: CurrentStable::HorsePolicy

      @dashboard = Dashboard::Horse::Shipments.new(horse:)
      render "horse/events/shipments"
    end

    def new
      horse = Horses::Horse.find(params[:id])
      authorize horse, :ship?, policy_class: CurrentStable::HorsePolicy

      @shipment = horse.racehorse? ? horse.racing_shipments.build : horse.broodmare_shipments.build
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :ship?, policy_class: CurrentStable::HorsePolicy
    end
  end
end

