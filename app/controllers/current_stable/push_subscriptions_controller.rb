class CurrentStable::PushSubscriptionsController < AuthenticatedController
  def create
    authorize %i[current_stable push_subscriptions]
    params = push_subscription_params.merge(user_agent: request.user_agent, user_id: Current.user.id)
    if (subscription = Current.user.push_subscriptions.find_or_create_by(params))
      subscription.update(updated_at: Time.current)
    else
      Account::PushSubscription.create! params
    end

    head :ok
  end

  def change
    authorize %i[current_stable push_subscriptions]

    subscription = Current.user.push_subscriptions.find_by!(endpoint: params[:old_endpoint])

    subscription.endpoint = new_endpoint if params[:new_endpoint]
    subscription.p256dh_key = new_p256dh if params[:new_p256dh]
    subscription.auth_key = new_auth if params[:new_auth]

    if subscription.save
      format.json { render :show, status: :ok, location: subscription }
    else
      format.json { render json: subscription.errors, status: :unprocessable_entity }
    end
  end

  private

  def push_subscription_params
    params.expect(push_subscription: [:endpoint, :p256dh_key, :auth_key])
  end
end

