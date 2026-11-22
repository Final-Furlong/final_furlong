class Horses::FamousStudNominationsController < AuthenticatedController
  def index
    query = policy_scope(Horses::Stud::FamousStudNomination.includes(:sire, :submitter))
    @pagy, @nominations = pagy(:countless, query)
  end

  def new
    @nomination = Horses::Stud::FamousStudNomination.new
    authorize @nomination, :create?
  end

  def create
    @nomination = Horses::Stud::FamousStudNomination.new
    authorize @nomination, :create?

    result = Stud::FamousStudNominator.new.create_nomination(nomination: @nomination, stable: Current.stable, params: stud_params)
    if result.created?
      flash[:success] = t(".success")
    else
      flash[:error] = t(".failure")
    end
    redirect_to horses_famous_stud_nominations_path
  end

  private

  def stud_params
    params.expect(horses_stud_famous_stud_nomination: [:name, :date_of_birth, :sire_id, :sire_name, :dam_name, :height, :color, :face_marking, :lf_leg_marking, :lh_leg_marking, :rf_leg_marking, :rh_leg_marking, :highlights, :ran_on_dirt, :ran_on_turf, :ran_on_steeplechase])
  end
end

