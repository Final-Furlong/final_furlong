module Horse
  class LeaseTerminationsController < ApplicationController
    def new
      horse = Horses::Horse.find(params[:id])
      @current_lease = horse.current_lease
      authorize @current_lease, :terminate?, policy_class: CurrentStable::LeasePolicy

      @termination_request = @current_lease.termination_request
    end

    def create
      horse = Horses::Horse.find(params[:id])
      @current_lease = horse.current_lease
      authorize @current_lease, :terminate?, policy_class: CurrentStable::LeasePolicy

      result = Horses::LeaseTerminator.new.call(current_lease: @current_lease, stable: Current.stable, params: lease_params)
      if result.terminated?
        flash[:success] = t(".success_with_termination")
      elsif result.created?
        flash[:success] = t(".success")
      else
        @termination_request = result.termination
        render :new and return
      end
      redirect_to horse_path(horse)
    end

    private

    def lease_params
      params.expect(horses_lease_termination_request: [:owner_accepted_end, :leaser_accepted_end, :owner_accepted_refund, :leaser_accepted_refund])
    end
  end
end

