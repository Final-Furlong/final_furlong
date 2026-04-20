module Horse
  class StudNominationsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      @dashboard = Dashboard::Horse::StudNomination.new(horse: @horse)
    end

    def new
    end

    def create
    end
  end
end

