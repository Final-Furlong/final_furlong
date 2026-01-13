resource :stable, only: %i[show edit update], controller: "stables", as: :current_stable

namespace :stable, module: "current_stable" do
  resources :auctions, only: %i[index show]
  resources :budgets, only: %i[index]
  resources :horses, only: %i[index edit show update]
  resources :lease_offers, only: :index
  resources :leases, only: :index
  resources :sale_offers, only: :index
  resources :trainings, only: :index
  resources :training, only: :show
  resources :training_schedules do
    resources :horses, controller: "training_schedule_horses", only: %i[index new create destroy]
  end
  resources :workouts, only: %i[create]
  resources :settings, only: %i[new]
  resources :shipments, only: :index
end

