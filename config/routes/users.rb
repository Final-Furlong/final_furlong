devise_for :users, class_name: "Account::User", path: "", path_names: {
  sign_up: "join",
  sign_in: "login",
  sign_out: "logout",
  password: "forgot-password",
  confirmation: "confirm-account",
  unlock: "unlock"
}, controllers: {
  registrations: "users/registrations"
}

get "/activation_required", to: "pages#activation", as: :activation

resources :users
resources :settings, only: :create

