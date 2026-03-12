namespace :horses, module: "horses" do
  resources :lease_offers, only: :index
  resources :sale_offers, only: :index
end

resources :horses, except: %i[new create destroy] do
  member do
    get :image
    get :thumbnail
    get :edit_name
    scope module: :horse, as: "horse" do
      resource :auction_consignment, only: %i[new create]
      resources :boardings, only: %i[index destroy]
      resources :events, only: :index
      resources :foals, only: :index
      resources :images, only: :index
      resources :injuries, only: :index
      resource :lease_offer, only: %i[new create destroy]
      resource :lease_offer_acceptance, only: :create
      resource :lease_termination, only: %i[new create]
      resource :pedigree, only: :show
      resource :race_options, only: %i[edit update]
      resources :race_stats, only: %i[index]
      resources :races, only: :index
      resource :sale_offer, only: %i[new create destroy]
      resource :sale_offer_acceptance, only: :create
      resources :sales, only: :index
      resources :shipments, only: %i[index new create]
      resources :workouts, only: %i[index new create]
      resources :workout_stats, only: %i[index]
    end
    delete "shipments/:shipment_id", to: "horse/shipments#destroy", as: :shipment
  end
end

resources :auctions do
  scope module: "auctions" do
    resources :horses do
      resources :bids, only: %i[new create]
    end
  end
end

