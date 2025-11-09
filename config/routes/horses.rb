resources :horses, except: %i[new create destroy] do
  member do
    get :image
    get :thumbnail
    scope module: :horse do
      resource :lease, only: %i[new create show]
      resource :lease_termination, only: %i[new create]
      resources :races, only: :index
      resources :foals, only: :index
      resources :images, only: :index
      resource :pedigree, only: :show
    end
  end
end

