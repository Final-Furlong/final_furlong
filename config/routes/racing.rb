namespace :racing do
  resources :racehorses, only: :index
  resources :entries
  resources :races, only: :index do
    get :post_parade, on: :collection
    get :racing_form, on: :member
  end
  resources :results, only: :index
  get "races/:date/:number", to: "races#show", as: :race
  get "results/:date/:number", to: "results#show", as: :result
end

