class Pwa::WebPushesController < ApplicationController
  def create
    authorize %i[current_stable push_subscriptions]
    Pwa::WebPushJob.perform_later(
      title: web_push_params[:title],
      message: web_push_params[:message],
      subscription: JSON.parse(web_push_params[:subscription])
    )

    head :ok
  end

  private

  def web_push_params
    params.expect(web_push: [:title, :message, :subscription])
  end
end

