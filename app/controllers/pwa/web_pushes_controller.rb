class Pwa::WebPushesController < ApplicationController
  def create
    authorize %i[current_stable push_subscriptions]
    begin
      parsed_json = JSON.parse(web_push_params[:subscription])
      Pwa::WebPushJob.perform_later(
        title: web_push_params[:title],
        message: web_push_params[:message],
        subscription: parsed_json
      )
    rescue JSON::ParserError
      head :ok and return
    end

    head :ok
  end

  private

  def web_push_params
    params.expect(web_push: [:title, :message, :subscription])
  end
end

