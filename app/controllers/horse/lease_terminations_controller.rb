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
        redirect_to horse_path(horse)
      elsif result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(horse)
      else
        @termination_request = result.termination
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("lease-termination-form", partial: "horse/lease_terminations/form",
              locals: { termination_request: @termination_request, current_lease: @current_lease })
          end
        end
      end
    end

    private

    def lease_params
      params.expect(horses_lease_termination_request: [:owner_accepted_end, :leaser_accepted_end, :owner_accepted_refund, :leaser_accepted_refund])
    end
  end
end

