module Horse
  class FoalsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.includes(:broodmare_foal_record, :stud_foal_record, next_foal: :stud).find(params[:id])
      authorize horse, :show?

      foal_type = horse.female? ? :foals : :stud_foals
      includes = horse.female? ? %i[lifetime_race_record sire] : %i[lifetime_race_record dam]
      born_query = horse.send(foal_type).born.includes(includes).order(date_of_birth: :asc)
      pagy, born_foals = pagy(:countless, born_query)

      @dashboard = Dashboard::Horse::Foals.new(horse:, pagy:, born_foals:)
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

