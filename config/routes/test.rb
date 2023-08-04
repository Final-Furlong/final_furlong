namespace :test do
  resources :sessions, only: :create

  resource :session, only: [] do
    match :destroy, as: "destroy", via: :delete
  end

  resources :factories, only: :create

  resource :factory, only: [] do
    match :show, via: :get
    match :update, as: "update", via: %i[put patch]
  end
end

