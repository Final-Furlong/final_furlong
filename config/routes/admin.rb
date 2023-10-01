mount Motor::Admin => "/motor_admin"
mount Sidekiq::Web => "/sidekiq"

namespace :admin do
  resource :impersonate, only: %i[create destroy]
end

