namespace :horses, module: "horses" do
  resources :lease_offers, only: :index
end

resources :horses, except: %i[new create destroy] do
  member do
    get :image
    get :thumbnail
    scope module: :horse do
      resource :lease_offer, only: %i[new create destroy]
      resource :lease_offer_acceptance, only: :create
      resource :lease_termination, only: %i[new create]
      resources :races, only: :index
      resources :foals, only: :index
      resources :images, only: :index
      resource :pedigree, only: :show
    end
  end
end

