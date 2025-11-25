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
      @shipment = horse.racehorse? ? horse.racing_shipments.build : horse.broodmare_shipments.build
      authorize @shipment, :create?, policy_class: CurrentStable::HorseShipmentPolicy
    end

    def create
      horse = Horses::Horse.find(params[:id])
      shipment = horse.racehorse? ? horse.racing_shipments.build : horse.broodmare_shipments.build
      authorize shipment, :create?, policy_class: CurrentStable::HorseShipmentPolicy

      result = creator_class(horse).new.ship_horse(horse:, params: shipment_params)
      if result.created?
        shipment = result.shipment
        flash[:success] = shipment.future? ? t(".success_scheduled") : t(".success")
        redirect_to horse_path(horse)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            pd result
            partial = horse.racehorse? ? "horse/shipments/racing_form" : "horse/shipments/broodmare_form"
            render turbo_stream: turbo_stream.replace("shipment-form", partial:, locals: { shipment: result.shipment, horse: })
          end
        end
      end
    end

    def destroy
      @horse = Horses::Horse.find(params[:id])
      shipment = @horse.racehorse? ? Shipping::RacehorseShipment.find(params[:shipment_id]) : Shipping::BroodmareShipment.find(params[:shipment_id])
      authorize shipment, :destroy?, policy_class: CurrentStable::HorseShipmentPolicy

      if shipment.destroy!
        flash[:success] = t(".success") # rubocop:disable Rails/ActionControllerFlashBeforeRender
        respond_to do |format|
          format.turbo_stream { render :destroy }
          format.html { redirect_to horse_path(@horse), success: t(".success") }
        end
      else
        flash[:error] = t("common.error")
        redirect_to horse_path(@horse)
      end
    end

    private

    def creator_class(horse)
      horse.racehorse? ? Horses::Racing::ShipmentCreator : Horses::Broodmare::ShipmentCreator
    end

    def shipment_params
      params.expect(shipment: [:departure_date, :ending_location, :ending_farm, :mode])
    end
  end
end

