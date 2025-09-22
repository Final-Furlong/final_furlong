authenticate :user, lambda { |user| user.admin? } do
  mount Motor::Admin => "/motor_admin"
  mount MissionControl::Jobs::Engine, at: "/jobs"

  namespace :admin do
    resource :impersonate, only: %i[create destroy]
  end
end

