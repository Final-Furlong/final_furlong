module Horse
  class FoalsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :show?

      @dashboard = Dashboard::Horse::Foals.new(horse:)
    end

    def create
      horse = Horses::Horse.broodmare.find(params[:id])
      authorize horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      pd params
      pd horse.manager
      breeding = Horses::Breeding.find_by(stable: horse.manager, id: params[:booking_id])
      pd breeding

      result = ::Horses::BreedingProcessor.new.do_breeding(breeding:, mare: horse, stud: breeding.stud)
      if result.updated?
        flash[:success] = t(".success")
        redirect_to horse_path(horse)
      else
        flash[:error] = result.error
      end

      redirect_to horse_path(horse)
    end
  end
end

