def define_test_routes # rubocop:disable Metrics/MethodLength
  Rails.logger.info "Loading routes meant only for testing purposes"

  namespace :test do
    resources :sessions, only: :create

    resource :session, only: [] do
      match :destroy, as: "destroy", via: :delete
    end

    resources :factories, only: :create

    resource :factory, only: [] do
      match :update, as: "update", via: %i[put patch]
    end
  end
end

