module Horse
  class LeasesController < ApplicationController
    def show
      horse = Horses::Horse.find(params[:id])
      @current_lease = horse.current_lease
    end

    def new
    end

    def create
    end
  end
end

