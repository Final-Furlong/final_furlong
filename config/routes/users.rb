devise_for :users, class_name: "Account::User", path: "", path_names: {
  sign_up: "join",
  sign_in: "login",
  sign_out: "logout",
  password: "forgot-password",
  confirmation: "confirm-account",
  unlock: "unlock"
}, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

get "/activation_required", to: "pages#activation", as: :activation

resources :users
resources :settings, only: :create

namespace :pwa do
  resources :web_pushes, only: [:create]
end

post "/push_subscriptions", to: "current_stable/push_subscriptions#create"
post "/push_subscriptions/change", to: "current_stable/push_subscriptions#change", as: "change_notifications"

