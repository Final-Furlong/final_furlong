Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  devise_for :users, path: "", path_names: {
    sign_up: "join",
    sign_in: "login",
    sign_out: "logout",
    password: "forgot-password",
    confirmation: "confirm-account",
    unlock: "unlock"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users

  # Defines the root path route ("/")
  root "pages#home"
end

# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                              rails_admin        /admin                                                                                            RailsAdmin::Engine
#                         new_user_session GET    /login(.:format)                                                                                  devise/sessions#new
#                             user_session POST   /login(.:format)                                                                                  devise/sessions#create
#                     destroy_user_session DELETE /logout(.:format)                                                                                 devise/sessions#destroy
#                        new_user_password GET    /forgot-password/new(.:format)                                                                    devise/passwords#new
#                       edit_user_password GET    /forgot-password/edit(.:format)                                                                   devise/passwords#edit
#                            user_password PATCH  /forgot-password(.:format)                                                                        devise/passwords#update
#                                          PUT    /forgot-password(.:format)                                                                        devise/passwords#update
#                                          POST   /forgot-password(.:format)                                                                        devise/passwords#create
#                 cancel_user_registration GET    /cancel(.:format)                                                                                 devise/registrations#cancel
#                    new_user_registration GET    /join(.:format)                                                                                   devise/registrations#new
#                   edit_user_registration GET    /edit(.:format)                                                                                   devise/registrations#edit
#                        user_registration PATCH  /                                                                                                 devise/registrations#update
#                                          PUT    /                                                                                                 devise/registrations#update
#                                          DELETE /                                                                                                 devise/registrations#destroy
#                                          POST   /                                                                                                 devise/registrations#create
#                    new_user_confirmation GET    /confirm-account/new(.:format)                                                                    devise/confirmations#new
#                        user_confirmation GET    /confirm-account(.:format)                                                                        devise/confirmations#show
#                                          POST   /confirm-account(.:format)                                                                        devise/confirmations#create
#                          new_user_unlock GET    /unlock/new(.:format)                                                                             devise/unlocks#new
#                              user_unlock GET    /unlock(.:format)                                                                                 devise/unlocks#show
#                                          POST   /unlock(.:format)                                                                                 devise/unlocks#create
#                                    users GET    /users(.:format)                                                                                  users#index
#                                          POST   /users(.:format)                                                                                  users#create
#                                 new_user GET    /users/new(.:format)                                                                              users#new
#                                edit_user GET    /users/:id/edit(.:format)                                                                         users#edit
#                                     user GET    /users/:id(.:format)                                                                              users#show
#                                          PATCH  /users/:id(.:format)                                                                              users#update
#                                          PUT    /users/:id(.:format)                                                                              users#update
#                                          DELETE /users/:id(.:format)                                                                              users#destroy
#                                     root GET    /                                                                                                 pages#home
#         turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#            rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#       edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                          PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
# new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for RailsAdmin::Engine:
#   dashboard GET         /                                      rails_admin/main#dashboard
#       index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#         new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#      export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
# bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
# bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#        show GET         /:model_name/:id(.:format)             rails_admin/main#show
#        edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#      delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
# show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
