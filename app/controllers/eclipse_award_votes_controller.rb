class EclipseAwardVotesController < AuthenticatedController
  def create
    @contender = Game::EclipseAwardContender.find(params[:contender_id])
    authorize @contender, :vote?

    vote = Game::EclipseAwardVote.new(contender: @contender, voter: Current.stable, category: @contender.category)
    ActiveRecord::Base.transaction do
      if vote.save
        EclipseAwardVotingNotification.where(user: Current.user).param_equals("year", @contender.year).param_equals("category", @contender.category).delete_all
      end
    end

    if vote.persisted?
      flash[:success] = t(".success", name: @contender.awardable.name)
    else
      flash[:alert] = t(".failure")
    end
    redirect_to root_path
  end
end

