devise_scope :user do
  get "/join" => "devise/registrations#new", :as => :new_user_registration
  delete "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
end
devise_for :users, class_name: "Account::User", path_names: {
  sign_out: "logout",
  confirmation: "confirm-account",
  unlock: "unlock"
}, controllers: {
  confirmations: "users/confirmations",
  sessions: "users/sessions"
}

resources :users, except: %i[new create destroy]
resources :notifications, only: %i[index update destroy]
resources :settings, only: %i[new create]
resource :sso_login, only: :show
resource :sso, only: :show

namespace :pwa do
  resources :web_pushes, only: [:create]
end

post "/push_subscriptions", to: "current_stable/push_subscriptions#create"
post "/push_subscriptions/change", to: "current_stable/push_subscriptions#change", as: "change_notifications"

