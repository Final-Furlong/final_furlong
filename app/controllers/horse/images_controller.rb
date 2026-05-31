module Horse
  class ImagesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :show?
    end
  end
end

