namespace :racing do
  resources :races, only: :index
  resources :results, only: :index
  get "races/:date/:number", to: "races#show", as: :race
  get "results/:date/:number", to: "results#show", as: :result
end

