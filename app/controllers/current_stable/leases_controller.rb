module CurrentStable
  class LeasesController < AuthenticatedController
    def index
      if params[:role].blank?
        if Horses::Lease.leased_by(Current.stable).exists?
          params[:role] = "leasee"
        elsif Horses::Lease.owned_by(Current.stable).exists?
          params[:role] = "leaser"
        end
      end
      query = policy_scope(Horses::Lease).includes(:termination_request)
      if params[:role] == "leasee"
        query = query.leased_by(Current.stable).includes(:leaser, :owner, horse: :owner)
      elsif params[:role] == "leaser"
        query = query.owned_by(Current.stable).includes(:leaser, :horse, :owner)
      end
      @pagy, @leases = pagy(:offset, query)
    end
  end
end

