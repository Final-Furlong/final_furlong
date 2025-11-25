module CurrentStable
  class ShipmentsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      query = Horses::Horse.managed_by(Current.stable)

      @dashboard = Dashboard::Stable::Shipments.new(query:)
    end
  end
end

