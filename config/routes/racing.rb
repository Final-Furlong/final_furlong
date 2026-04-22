namespace :racing do
  resources :racehorses, only: :index
  resources :entries, only: :index do
    resources :claims, only: %i[new create destroy]
  end
  resources :races, only: :index do
    get :post_parade, on: :collection
    get :racing_form, on: :member
    resources :entries, only: %i[new destroy]
    resources :entry_options, only: %i[new create edit update]
  end
  resources :results, only: :index
  get "races/:date/:number", to: "races#show", as: :race
  get "results/:date/:number", to: "results#show", as: :result
  resources :tracks, only: :index
end

