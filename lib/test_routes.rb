def define_test_routes
  Rails.logger.info "Loading routes meant only for testing purposes"

  namespace :test do
    resources :sessions, only: :create

    resource :session, only: [] do
      match :destroy, as: "destroy", via: :delete
    end

    resources :factories, only: :create
  end
end

