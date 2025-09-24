resource :stable, only: %i[show edit update], controller: "stables", as: :current_stable
namespace :stable, module: "current_stable" do
  resources :horses, only: %i[index edit show update]
  resources :training_schedules do
    resources :horses, controller: "training_schedule_horses", only: %i[index new create destroy]
  end
  resources :workouts, only: %i[create]
end

