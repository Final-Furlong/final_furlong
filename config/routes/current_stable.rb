resource :stable, only: %i[show edit update], controller: "stables", as: :current_stable

namespace :stable, module: "current_stable" do
  resources :auctions, only: %i[index show]
  resources :boardings, only: %i[index new create update]
  resources :budgets, only: %i[index]
  resources :current_boardings, only: :index
  get "/current_entries(/:date)", to: "current_entries#index", as: :current_entries
  get "/future_entries(/:date)", to: "future_entries#show", as: :future_entries
  resources :historical_boardings, only: :index
  resources :horses, only: %i[index edit show update]
  resources :lease_offers, only: :index
  resources :leases, only: :index
  resources :race_results, only: :index do
    get :summary, on: :collection
    get :list, on: :collection
  end
  get "/recent_results/:date", to: "recent_results#show", as: :recent_results
  resources :sale_offers, only: :index
  resources :settings, only: %i[new]
  resources :shipments, only: :index
  resources :trainings, only: :index
  resources :training_schedules do
    resources :horses, controller: "training_schedule_horses", only: %i[index create destroy]
  end
  resource :training_summary, only: :show
  resources :workouts, only: %i[index create]
end

