devise_for :users, class_name: "Account::User", path: "", path_names: {
  sign_up: "join",
  sign_out: "logout",
  confirmation: "confirm-account",
  unlock: "unlock"
}, controllers: {
  confirmations: "users/confirmations",
  sessions: "users/sessions"
}
devise_scope :user do
  get "edit", to: "devise/registrations#edit", as: :edit_user_registration
  patch "/", to: "devise/registrations#update", as: :user_registration
  delete "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
end

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

