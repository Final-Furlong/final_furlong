module CurrentStable
  class ShipmentsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @dashboard = Dashboard::Stable::Shipments.new(stable: Current.stable)
    end
  end
end

