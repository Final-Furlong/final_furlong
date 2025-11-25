Rails.application.routes.draw do
  mount Api::Base, at: "/"

  draw(:admin)
  draw(:users)
  draw(:current_stable)
  draw(:horses)
  draw(:racing)

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_error", via: :all

  resources :stables, only: %i[index show]

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  unauthenticated do
    root to: "pages#home"
  end

  authenticated :user do
    root to: "stables#show", as: :authenticated_root
  end
end

# == Route Map
#
# Routes for application:
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                 api_base        /                                                                                                 Api::Base
#                        admin_impersonate DELETE /admin/impersonate(.:format)                                                                      admin/impersonates#destroy
#                                          POST   /admin/impersonate(.:format)                                                                      admin/impersonates#create
#                         new_user_session GET    /login(.:format)                                                                                  users/sessions#new
#                             user_session POST   /login(.:format)                                                                                  users/sessions#create
#                     destroy_user_session DELETE /logout(.:format)                                                                                 users/sessions#destroy
#                        new_user_password GET    /forgot-password/new(.:format)                                                                    devise/passwords#new
#                       edit_user_password GET    /forgot-password/edit(.:format)                                                                   devise/passwords#edit
#                            user_password PATCH  /forgot-password(.:format)                                                                        devise/passwords#update
#                                          PUT    /forgot-password(.:format)                                                                        devise/passwords#update
#                                          POST   /forgot-password(.:format)                                                                        devise/passwords#create
#                 cancel_user_registration GET    /cancel(.:format)                                                                                 users/registrations#cancel
#                    new_user_registration GET    /join(.:format)                                                                                   users/registrations#new
#                   edit_user_registration GET    /edit(.:format)                                                                                   users/registrations#edit
#                        user_registration PATCH  /                                                                                                 users/registrations#update
#                                          PUT    /                                                                                                 users/registrations#update
#                                          DELETE /                                                                                                 users/registrations#destroy
#                                          POST   /                                                                                                 users/registrations#create
#                    new_user_confirmation GET    /confirm-account/new(.:format)                                                                    devise/confirmations#new
#                        user_confirmation GET    /confirm-account(.:format)                                                                        devise/confirmations#show
#                                          POST   /confirm-account(.:format)                                                                        devise/confirmations#create
#                          new_user_unlock GET    /unlock/new(.:format)                                                                             devise/unlocks#new
#                              user_unlock GET    /unlock(.:format)                                                                                 devise/unlocks#show
#                                          POST   /unlock(.:format)                                                                                 devise/unlocks#create
#                               activation GET    /activation_required(.:format)                                                                    pages#activation
#                                    users GET    /users(.:format)                                                                                  users#index
#                                          POST   /users(.:format)                                                                                  users#create
#                                 new_user GET    /users/new(.:format)                                                                              users#new
#                                edit_user GET    /users/:id/edit(.:format)                                                                         users#edit
#                                     user GET    /users/:id(.:format)                                                                              users#show
#                                          PATCH  /users/:id(.:format)                                                                              users#update
#                                          PUT    /users/:id(.:format)                                                                              users#update
#                                          DELETE /users/:id(.:format)                                                                              users#destroy
#                            notifications GET    /notifications(.:format)                                                                          notifications#index
#                             notification PATCH  /notifications/:id(.:format)                                                                      notifications#update
#                                          PUT    /notifications/:id(.:format)                                                                      notifications#update
#                                          DELETE /notifications/:id(.:format)                                                                      notifications#destroy
#                                 settings POST   /settings(.:format)                                                                               settings#create
#                              new_setting GET    /settings/new(.:format)                                                                           settings#new
#                           pwa_web_pushes POST   /pwa/web_pushes(.:format)                                                                         pwa/web_pushes#create
#                       push_subscriptions POST   /push_subscriptions(.:format)                                                                     current_stable/push_subscriptions#create
#                     change_notifications POST   /push_subscriptions/change(.:format)                                                              current_stable/push_subscriptions#change
#                      edit_current_stable GET    /stable/edit(.:format)                                                                            stables#edit
#                           current_stable GET    /stable(.:format)                                                                                 stables#show
#                                          PATCH  /stable(.:format)                                                                                 stables#update
#                                          PUT    /stable(.:format)                                                                                 stables#update
#                           stable_budgets GET    /stable/budgets(.:format)                                                                         current_stable/budgets#index
#                            stable_horses GET    /stable/horses(.:format)                                                                          current_stable/horses#index
#                        edit_stable_horse GET    /stable/horses/:id/edit(.:format)                                                                 current_stable/horses#edit
#                             stable_horse GET    /stable/horses/:id(.:format)                                                                      current_stable/horses#show
#                                          PATCH  /stable/horses/:id(.:format)                                                                      current_stable/horses#update
#                                          PUT    /stable/horses/:id(.:format)                                                                      current_stable/horses#update
#                            stable_leases GET    /stable/leases(.:format)                                                                          current_stable/leases#index
#          stable_training_schedule_horses GET    /stable/training_schedules/:training_schedule_id/horses(.:format)                                 current_stable/training_schedule_horses#index
#                                          POST   /stable/training_schedules/:training_schedule_id/horses(.:format)                                 current_stable/training_schedule_horses#create
#       new_stable_training_schedule_horse GET    /stable/training_schedules/:training_schedule_id/horses/new(.:format)                             current_stable/training_schedule_horses#new
#           stable_training_schedule_horse DELETE /stable/training_schedules/:training_schedule_id/horses/:id(.:format)                             current_stable/training_schedule_horses#destroy
#                stable_training_schedules GET    /stable/training_schedules(.:format)                                                              current_stable/training_schedules#index
#                                          POST   /stable/training_schedules(.:format)                                                              current_stable/training_schedules#create
#             new_stable_training_schedule GET    /stable/training_schedules/new(.:format)                                                          current_stable/training_schedules#new
#            edit_stable_training_schedule GET    /stable/training_schedules/:id/edit(.:format)                                                     current_stable/training_schedules#edit
#                 stable_training_schedule GET    /stable/training_schedules/:id(.:format)                                                          current_stable/training_schedules#show
#                                          PATCH  /stable/training_schedules/:id(.:format)                                                          current_stable/training_schedules#update
#                                          PUT    /stable/training_schedules/:id(.:format)                                                          current_stable/training_schedules#update
#                                          DELETE /stable/training_schedules/:id(.:format)                                                          current_stable/training_schedules#destroy
#                          stable_workouts POST   /stable/workouts(.:format)                                                                        current_stable/workouts#create
#                       new_stable_setting GET    /stable/settings/new(.:format)                                                                    current_stable/settings#new
#                      horses_lease_offers GET    /horses/lease_offers(.:format)                                                                    horses/lease_offers#index
#                              image_horse GET    /horses/:id/image(.:format)                                                                       horses#image
#                          thumbnail_horse GET    /horses/:id/thumbnail(.:format)                                                                   horses#thumbnail
#                          new_lease_offer GET    /horses/:id/lease_offer/new(.:format)                                                             horse/lease_offers#new
#                              lease_offer DELETE /horses/:id/lease_offer(.:format)                                                                 horse/lease_offers#destroy
#                                          POST   /horses/:id/lease_offer(.:format)                                                                 horse/lease_offers#create
#                   lease_offer_acceptance POST   /horses/:id/lease_offer_acceptance(.:format)                                                      horse/lease_offer_acceptances#create
#                    new_lease_termination GET    /horses/:id/lease_termination/new(.:format)                                                       horse/lease_terminations#new
#                        lease_termination POST   /horses/:id/lease_termination(.:format)                                                           horse/lease_terminations#create
#                                    races GET    /horses/:id/races(.:format)                                                                       horse/races#index
#                                    foals GET    /horses/:id/foals(.:format)                                                                       horse/foals#index
#                                   images GET    /horses/:id/images(.:format)                                                                      horse/images#index
#                                 pedigree GET    /horses/:id/pedigree(.:format)                                                                    horse/pedigrees#show
#                                   horses GET    /horses(.:format)                                                                                 horses#index
#                               edit_horse GET    /horses/:id/edit(.:format)                                                                        horses#edit
#                                    horse GET    /horses/:id(.:format)                                                                             horses#show
#                                          PATCH  /horses/:id(.:format)                                                                             horses#update
#                                          PUT    /horses/:id(.:format)                                                                             horses#update
#                                                 /404(.:format)                                                                                    errors#not_found
#                                                 /422(.:format)                                                                                    errors#unprocessable
#                                                 /500(.:format)                                                                                    errors#internal_error
#                                  stables GET    /stables(.:format)                                                                                stables#index
#                                   stable GET    /stables/:id(.:format)                                                                            stables#show
#                             pwa_manifest GET    /manifest(.:format)                                                                               rails/pwa#manifest
#                       pwa_service_worker GET    /service-worker(.:format)                                                                         rails/pwa#service_worker
#                                     root GET    /                                                                                                 pages#home
#                       authenticated_root GET    /                                                                                                 stables#show
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
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
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
# Routes for Motor::Admin:
#                                 Prefix Verb   URI Pattern                                             Controller#Action
#
# Routes for MissionControl::Jobs::Engine:
#                      Prefix Verb   URI Pattern                                                    Controller#Action
#
# Routes for PgHero::Engine:
#                    Prefix Verb URI Pattern                                      Controller#Action
#              system_stats GET  (/:database)/system_stats(.:format)              redirect(301, system)
#               query_stats GET  (/:database)/query_stats(.:format)               redirect(301, queries)

