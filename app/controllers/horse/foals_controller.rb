module Horse
  class FoalsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :show?

      @dashboard = Dashboard::Horse::Foals.new(horse:)
    end

    def new
      horse = Horses::Horse.broodmare.find(params[:id])
      authorize horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @breeding = Horses::Breeding.find_by(stable: horse.manager, id: params[:booking_id])
      @breeding.mare = horse
    end

    def create
      horse = Horses::Horse.broodmare.find(params[:id])
      authorize horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      breeding = Horses::Breeding.find_by(stable: horse.manager, id: params[:booking_id])

      result = ::Horses::BreedingProcessor.new.do_breeding(breeding:, mare: horse, stud: breeding.stud, day: breeding_params[:day])
      if result.updated?
        flash[:success] = t(".success")
      else
        flash[:error] = result.error
      end

      redirect_to horse_path(horse)
    end

    private

    def breeding_params
      params.expect(horses_breeding: [:day])
    end
  end
end

