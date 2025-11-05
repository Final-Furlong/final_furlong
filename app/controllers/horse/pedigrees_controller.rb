module Horse
  class PedigreesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :show

    def show
      @horse = Horses::Horse.includes(sire: :sire, dam: :dam).find(params[:id])
      authorize @horse, :show?
    end
  end
end

