class EclipseAwardContendersController < AuthenticatedController
  def index
    raise ActiveRecord::RecordNotFound unless valid_params?

    @contenders = policy_scope(Game::EclipseAwardContender.where(year: params[:year], category: params[:category])).order("RANDOM()")
  end

  private

  def valid_params?
    params.key?(:year) && params.key?(:category)
  end
end

