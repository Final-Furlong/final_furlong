module Horse
  class SalesController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :view_sales?, policy_class: CurrentStable::HorsePolicy

      @dashboard = Dashboard::Horse::Sales.new(horse:)
      render "horse/events/sales"
    end
  end
end

