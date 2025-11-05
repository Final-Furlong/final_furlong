module Horse
  class FoalsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :show?

      @dashboard = Dashboard::Horse::Foals.new(horse:)
    end
  end
end

