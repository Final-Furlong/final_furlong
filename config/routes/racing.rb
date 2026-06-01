namespace :racing do
  resources :breeders_cup_qualifiers, only: %i[index show]
  resources :breeders_series_qualifiers, only: %i[index show]
  resources :racehorses, only: :index
  resources :entries, only: :index do
    resources :claims, only: %i[new create destroy]
  end
  resources :races, only: :index do
    get :all, on: :collection
    get :post_parade, on: :collection
    get :racing_form, on: :member
    resources :scheduled_entries, only: :index
    resources :entries, only: %i[new destroy]
    resources :entry_options, only: %i[new create edit update]
  end
  resources :series_winners, only: %i[index show]
  resources :results, only: :index
  get "races/:date/:number", to: "races#show", as: :race
  get "results/:date/:number", to: "results#show", as: :result
  resources :tracks, only: :index
end

