class EclipseAwardsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :index

  def index
    @query = Game::EclipseAward.ransack(params[:q])
    @query.sorts = ["year asc", "category asc", "horse_name asc"] if @query.sorts.blank?
    @pagy, @awards = pagy(:countless, @query.result)
  end
end

