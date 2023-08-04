require "sidekiq/web"

Rails.application.routes.draw do
  mount Motor::Admin => "/motor_admin"
  mount Api::Base, at: "/"

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_error", via: :all

  namespace :admin do
    resource :impersonate, only: %i[create show destroy]
  end

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
  get "/test_email", to: "pages#test_email", as: :test_email

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users
  resources :stables, only: %i[index show]
  resources :horses, except: %i[new create destroy]

  match "/settings", to: "settings#update", as: :settings, via: %i[put patch]

  # stable horses
  get "/stable", to: "stables#show", as: :current_stable
  get "/stable/edit", to: "stables#edit", as: :edit_current_stable
  match "/stable/edit", to: "stables#update", as: :update_current_stable, via: %i[put patch]
  get "/stable/horses", to: "current_stable/horses#index", as: :current_stable_horses
  get "/stable/horses/:id/edit", to: "current_stable/horses#edit", as: :edit_current_stable_horse
  get "/stable/horses/:id", to: "current_stable/horses#show", as: :current_stable_horse
  match "/stable/horses/:id", to: "current_stable/horses#update", as: :update_current_stable_horse, via: %i[put patch]

  if Rails.env.test?
    draw(:test)
  end

  unauthenticated do
    root to: "pages#home"
  end

  authenticated :user do
    root to: "stables#show", as: :authenticated_root
  end
end

# == Route Map
#
#                                   Prefix Verb      URI Pattern                                                                                       Controller#Action
#                              motor_admin           /motor_admin                                                                                      Motor::Admin
#                                 api_base           /                                                                                                 Api::Base
#                              sidekiq_web           /sidekiq                                                                                          Sidekiq::Web
#                                                    /404(.:format)                                                                                    errors#not_found
#                                                    /422(.:format)                                                                                    errors#unprocessable
#                                                    /500(.:format)                                                                                    errors#internal_error
#                        admin_impersonate GET       /admin/impersonate(.:format)                                                                      admin/impersonates#show
#                                          DELETE    /admin/impersonate(.:format)                                                                      admin/impersonates#destroy
#                                          POST      /admin/impersonate(.:format)                                                                      admin/impersonates#create
#                         new_user_session GET       /login(.:format)                                                                                  devise/sessions#new
#                             user_session POST      /login(.:format)                                                                                  devise/sessions#create
#                     destroy_user_session DELETE    /logout(.:format)                                                                                 devise/sessions#destroy
#                        new_user_password GET       /forgot-password/new(.:format)                                                                    devise/passwords#new
#                       edit_user_password GET       /forgot-password/edit(.:format)                                                                   devise/passwords#edit
#                            user_password PATCH     /forgot-password(.:format)                                                                        devise/passwords#update
#                                          PUT       /forgot-password(.:format)                                                                        devise/passwords#update
#                                          POST      /forgot-password(.:format)                                                                        devise/passwords#create
#                 cancel_user_registration GET       /cancel(.:format)                                                                                 users/registrations#cancel
#                    new_user_registration GET       /join(.:format)                                                                                   users/registrations#new
#                   edit_user_registration GET       /edit(.:format)                                                                                   users/registrations#edit
#                        user_registration PATCH     /                                                                                                 users/registrations#update
#                                          PUT       /                                                                                                 users/registrations#update
#                                          DELETE    /                                                                                                 users/registrations#destroy
#                                          POST      /                                                                                                 users/registrations#create
#                    new_user_confirmation GET       /confirm-account/new(.:format)                                                                    devise/confirmations#new
#                        user_confirmation GET       /confirm-account(.:format)                                                                        devise/confirmations#show
#                                          POST      /confirm-account(.:format)                                                                        devise/confirmations#create
#                          new_user_unlock GET       /unlock/new(.:format)                                                                             devise/unlocks#new
#                              user_unlock GET       /unlock(.:format)                                                                                 devise/unlocks#show
#                                          POST      /unlock(.:format)                                                                                 devise/unlocks#create
#                               activation GET       /activation_required(.:format)                                                                    pages#activation
#                                    users GET       /users(.:format)                                                                                  users#index
#                                          POST      /users(.:format)                                                                                  users#create
#                                 new_user GET       /users/new(.:format)                                                                              users#new
#                                edit_user GET       /users/:id/edit(.:format)                                                                         users#edit
#                                     user GET       /users/:id(.:format)                                                                              users#show
#                                          PATCH     /users/:id(.:format)                                                                              users#update
#                                          PUT       /users/:id(.:format)                                                                              users#update
#                                          DELETE    /users/:id(.:format)                                                                              users#destroy
#                                  stables GET       /stables(.:format)                                                                                stables#index
#                                   stable GET       /stables/:id(.:format)                                                                            stables#show
#                                   horses GET       /horses(.:format)                                                                                 horses#index
#                               edit_horse GET       /horses/:id/edit(.:format)                                                                        horses#edit
#                                    horse GET       /horses/:id(.:format)                                                                             horses#show
#                                          PATCH     /horses/:id(.:format)                                                                             horses#update
#                                          PUT       /horses/:id(.:format)                                                                             horses#update
#                                 settings PUT|PATCH /settings(.:format)                                                                               settings#update
#                           current_stable GET       /stable(.:format)                                                                                 stables#show
#                      edit_current_stable GET       /stable/edit(.:format)                                                                            stables#edit
#                    update_current_stable PUT|PATCH /stable/edit(.:format)                                                                            stables#update
#                    current_stable_horses GET       /stable/horses(.:format)                                                                          current_stable/horses#index
#                edit_current_stable_horse GET       /stable/horses/:id/edit(.:format)                                                                 current_stable/horses#edit
#                     current_stable_horse GET       /stable/horses/:id(.:format)                                                                      current_stable/horses#show
#              update_current_stable_horse PUT|PATCH /stable/horses/:id(.:format)                                                                      current_stable/horses#update
#                                     root GET       /                                                                                                 pages#home
#                       authenticated_root GET       /                                                                                                 stables#show
#         turbo_recede_historical_location GET       /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET       /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET       /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#            rails_postmark_inbound_emails POST      /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST      /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST      /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET       /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST      /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST      /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET       /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST      /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET       /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#       edit_rails_conductor_inbound_email GET       /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
#            rails_conductor_inbound_email GET       /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                          PATCH     /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          PUT       /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          DELETE    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
# new_rails_conductor_inbound_email_source GET       /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST      /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST      /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST      /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET       /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET       /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET       /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET       /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET       /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET       /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET       /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT       /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST      /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for Motor::Admin:
#                motor_api_run_queries POST   /api/run_queries(.:format)                              motor/run_queries#create
#                  motor_api_run_query GET    /api/run_queries/:id(.:format)                          motor/run_queries#show
#                motor_api_send_alerts POST   /api/send_alerts(.:format)                              motor/send_alerts#create
#                motor_api_auth_tokens POST   /api/auth_tokens(.:format)                              motor/auth_tokens#create
#                    motor_api_queries GET    /api/queries(.:format)                                  motor/queries#index
#                                      POST   /api/queries(.:format)                                  motor/queries#create
#                      motor_api_query GET    /api/queries/:id(.:format)                              motor/queries#show
#                                      PATCH  /api/queries/:id(.:format)                              motor/queries#update
#                                      PUT    /api/queries/:id(.:format)                              motor/queries#update
#                                      DELETE /api/queries/:id(.:format)                              motor/queries#destroy
#                       motor_api_tags GET    /api/tags(.:format)                                     motor/tags#index
#                    motor_api_configs GET    /api/configs(.:format)                                  motor/configs#index
#                                      POST   /api/configs(.:format)                                  motor/configs#create
#                  motor_api_resources GET    /api/resources(.:format)                                motor/resources#index
#                                      POST   /api/resources(.:format)                                motor/resources#create
#            motor_api_resource_method GET    /api/resource_methods/:resource(.:format)               motor/resource_methods#show
#     motor_api_resource_default_query GET    /api/resource_default_queries/:resource(.:format)       motor/resource_default_queries#show
#               motor_api_schema_index GET    /api/schema(.:format)                                   motor/schema#index
#                     motor_api_schema GET    /api/schema/:resource(.:format)                         motor/schema#show
#                 motor_api_dashboards GET    /api/dashboards(.:format)                               motor/dashboards#index
#                                      POST   /api/dashboards(.:format)                               motor/dashboards#create
#                  motor_api_dashboard GET    /api/dashboards/:id(.:format)                           motor/dashboards#show
#                                      PATCH  /api/dashboards/:id(.:format)                           motor/dashboards#update
#                                      PUT    /api/dashboards/:id(.:format)                           motor/dashboards#update
#                                      DELETE /api/dashboards/:id(.:format)                           motor/dashboards#destroy
#            motor_api_run_api_request GET    /api/run_api_request(.:format)                          motor/run_api_requests#show
#                                      POST   /api/run_api_request(.:format)                          motor/run_api_requests#create
#        motor_api_run_graphql_request POST   /api/run_graphql_request(.:format)                      motor/run_graphql_requests#create
#                motor_api_api_configs GET    /api/api_configs(.:format)                              motor/api_configs#index
#                                      POST   /api/api_configs(.:format)                              motor/api_configs#create
#                 motor_api_api_config DELETE /api/api_configs/:id(.:format)                          motor/api_configs#destroy
#                      motor_api_forms GET    /api/forms(.:format)                                    motor/forms#index
#                                      POST   /api/forms(.:format)                                    motor/forms#create
#                       motor_api_form GET    /api/forms/:id(.:format)                                motor/forms#show
#                                      PATCH  /api/forms/:id(.:format)                                motor/forms#update
#                                      PUT    /api/forms/:id(.:format)                                motor/forms#update
#                                      DELETE /api/forms/:id(.:format)                                motor/forms#destroy
#                     motor_api_alerts GET    /api/alerts(.:format)                                   motor/alerts#index
#                                      POST   /api/alerts(.:format)                                   motor/alerts#create
#                      motor_api_alert GET    /api/alerts/:id(.:format)                               motor/alerts#show
#                                      PATCH  /api/alerts/:id(.:format)                               motor/alerts#update
#                                      PUT    /api/alerts/:id(.:format)                               motor/alerts#update
#                                      DELETE /api/alerts/:id(.:format)                               motor/alerts#destroy
#                      motor_api_icons GET    /api/icons(.:format)                                    motor/icons#index
# motor_api_active_storage_attachments POST   /api/data/active_storage__attachments(.:format)         motor/active_storage_attachments#create
#                     motor_api_audits GET    /api/audits(.:format)                                   motor/audits#index
#                    motor_api_session GET    /api/session(.:format)                                  motor/sessions#show
#                                      DELETE /api/session(.:format)                                  motor/sessions#destroy
#                                      PUT    /api/data/:resource/:resource_id/:method(.:format)      motor/data#execute {:resource_id=>/[^\/]+/}
# motor_api_resource_association_index GET    /api/data/:resource/:resource_id/:association(.:format) motor/data#index {:resource_id=>/[^\/]+/}
#                                      POST   /api/data/:resource/:resource_id/:association(.:format) motor/data#create {:resource_id=>/[^\/]+/}
#                                      GET    /api/data/:resource(.:format)                           motor/data#index
#                                      POST   /api/data/:resource(.:format)                           motor/data#create
#                   motor_api_resource GET    /api/data/:resource/:id(.:format)                       motor/data#show {:id=>/[^\/]+/}
#                                      PATCH  /api/data/:resource/:id(.:format)                       motor/data#update {:id=>/[^\/]+/}
#                                      PUT    /api/data/:resource/:id(.:format)                       motor/data#update {:id=>/[^\/]+/}
#                                      DELETE /api/data/:resource/:id(.:format)                       motor/data#destroy {:id=>/[^\/]+/}
#                          motor_asset GET    /assets/:filename                                       motor/assets#show {:filename=>/.+/}
#                                motor GET    /                                                       motor/ui#show
#                        motor_ui_data GET    /data(/*path)(.:format)                                 motor/ui#index
#                     motor_ui_reports GET    /reports(.:format)                                      motor/ui#index
#                      motor_ui_report GET    /reports/:id(.:format)                                  motor/ui#show
#                     motor_ui_queries GET    /queries(.:format)                                      motor/ui#index
#                   new_motor_ui_query GET    /queries/new(.:format)                                  motor/ui#new
#                       motor_ui_query GET    /queries/:id(.:format)                                  motor/ui#show
#                  motor_ui_dashboards GET    /dashboards(.:format)                                   motor/ui#index
#               new_motor_ui_dashboard GET    /dashboards/new(.:format)                               motor/ui#new
#                   motor_ui_dashboard GET    /dashboards/:id(.:format)                               motor/ui#show
#                      motor_ui_alerts GET    /alerts(.:format)                                       motor/ui#index
#                   new_motor_ui_alert GET    /alerts/new(.:format)                                   motor/ui#new
#                       motor_ui_alert GET    /alerts/:id(.:format)                                   motor/ui#show
#                       motor_ui_forms GET    /forms(.:format)                                        motor/ui#index
#                    new_motor_ui_form GET    /forms/new(.:format)                                    motor/ui#new
#                        motor_ui_form GET    /forms/:id(.:format)                                    motor/ui#show

