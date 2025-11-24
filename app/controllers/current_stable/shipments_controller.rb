module CurrentStable
  class ShipmentsController < AuthenticatedController
    def index
      query = policy_scope(Horses::Horse.all, policy_scope_class:
        CurrentStable::HorseShipmentPolicy::Scope)

      @dashboard = Dashboard::Stable::Shipments.new(query:)
    end
  end
end

