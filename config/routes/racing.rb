namespace :racing do
  resources :races, only: :index
  get "races/:date/:number", to: "races#show"
end

