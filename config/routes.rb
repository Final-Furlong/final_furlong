Rails.application.routes.draw do
  mount Api::Base, at: "/"

  draw(:admin)
  draw(:users)
  draw(:current_stable)

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_error", via: :all

  resources :stables, only: %i[index show]
  resources :horses, except: %i[new create destroy] do
    member do
      get :image
      get :thumbnail
    end
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
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                 api_base        /                                                                                                 Api::Base
#                              motor_admin        /motor_admin                                                                                      Motor::Admin
#                     mission_control_jobs        /jobs                                                                                             MissionControl::Jobs::Engine
#                                  pg_hero        /pghero                                                                                           PgHero::Engine
#                        admin_impersonate DELETE /admin/impersonate(.:format)                                                                      admin/impersonates#destroy
#                                          POST   /admin/impersonate(.:format)                                                                      admin/impersonates#create
#                         new_user_session GET    /login(.:format)                                                                                  devise/sessions#new
#                             user_session POST   /login(.:format)                                                                                  devise/sessions#create
#                     destroy_user_session DELETE /logout(.:format)                                                                                 devise/sessions#destroy
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
#                                 settings POST   /settings(.:format)                                                                               settings#create
#                      edit_current_stable GET    /stable/edit(.:format)                                                                            stables#edit
#                           current_stable GET    /stable(.:format)                                                                                 stables#show
#                                          PATCH  /stable(.:format)                                                                                 stables#update
#                                          PUT    /stable(.:format)                                                                                 stables#update
#                            stable_horses GET    /stable/horses(.:format)                                                                          current_stable/horses#index
#                        edit_stable_horse GET    /stable/horses/:id/edit(.:format)                                                                 current_stable/horses#edit
#                             stable_horse GET    /stable/horses/:id(.:format)                                                                      current_stable/horses#show
#                                          PATCH  /stable/horses/:id(.:format)                                                                      current_stable/horses#update
#                                          PUT    /stable/horses/:id(.:format)                                                                      current_stable/horses#update
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
#                                                 /404(.:format)                                                                                    errors#not_found
#                                                 /422(.:format)                                                                                    errors#unprocessable
#                                                 /500(.:format)                                                                                    errors#internal_error
#                                  stables GET    /stables(.:format)                                                                                stables#index
#                                   stable GET    /stables/:id(.:format)                                                                            stables#show
#                              image_horse GET    /horses/:id/image(.:format)                                                                       horses#image
#                          thumbnail_horse GET    /horses/:id/thumbnail(.:format)                                                                   horses#thumbnail
#                                   horses GET    /horses(.:format)                                                                                 horses#index
#                               edit_horse GET    /horses/:id/edit(.:format)                                                                        horses#edit
#                                    horse GET    /horses/:id(.:format)                                                                             horses#show
#                                          PATCH  /horses/:id(.:format)                                                                             horses#update
#                                          PUT    /horses/:id(.:format)                                                                             horses#update
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
#                            motor_cable        /cable                                                  #<ActionCable::Server::Base:0x0000000124678930 @config=#<ActionCable::Server::Configuration:0x00000001253f29a8 @log_tags=[], @connection_class=#<Proc:0x0000000125214410 /Users/shanthi/.asdf/installs/ruby/3.4.5/lib/ruby/gems/3.4.0/gems/actioncable-8.0.3/lib/action_cable/engine.rb:55 (lambda)>, @worker_pool_size=4, @disable_request_forgery_protection=false, @allow_same_origin_as_host=true, @filter_parameters=[:passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc, /\Aio\z/], @health_check_application=#<Proc:0x00000001252164e0 /Users/shanthi/.asdf/installs/ruby/3.4.5/lib/ruby/gems/3.4.0/gems/actioncable-8.0.3/lib/action_cable/engine.rb:31 (lambda)>, @logger=#<ActiveSupport::BroadcastLogger:0x0000000123897d20 @broadcasts=[#<ActiveSupport::Logger:0x0000000124619660 @level=0, @progname=nil, @default_formatter=#<Logger::Formatter:0x0000000123898860 @datetime_format=nil>, @formatter=#<Logger::Formatter:0x00000001238981f8 @datetime_format=nil>, @logdev=#<Logger::LogDevice:0x00000001251b01e0 @shift_period_suffix="%Y%m%d", @shift_size=104857600, @shift_age=1, @filename="/Users/shanthi/code/final_furlong/log/development.log", @dev=#<File:/Users/shanthi/code/final_furlong/log/development.log>, @binmode=false, @reraise_write_errors=[], @skip_header=false, @mon_data=#<Monitor:0x0000000123898798>, @mon_data_owner_object_id=5584>, @level_override={}, @local_level_key=:logger_thread_safe_level_5592>], @progname="Broadcast">, @cable={"adapter" => "redis", "url" => "redis://localhost:6379/1"}, @mount_path="/cable", @precompile_assets=true, @allowed_request_origins=/https?:\/\/localhost:\d+/>, @mutex=#<Monitor:0x00000001251dc510>, @pubsub=nil, @worker_pool=nil, @event_loop=nil, @remote_connections=nil>
#                  motor_api_run_queries POST   /api/run_queries(.:format)                              motor/run_queries#create
#                    motor_api_run_query GET    /api/run_queries/:id(.:format)                          motor/run_queries#show
#                  motor_api_send_alerts POST   /api/send_alerts(.:format)                              motor/send_alerts#create
#                  motor_api_auth_tokens POST   /api/auth_tokens(.:format)                              motor/auth_tokens#create
#                      motor_api_queries GET    /api/queries(.:format)                                  motor/queries#index
#                                        POST   /api/queries(.:format)                                  motor/queries#create
#                        motor_api_query GET    /api/queries/:id(.:format)                              motor/queries#show
#                                        PATCH  /api/queries/:id(.:format)                              motor/queries#update
#                                        PUT    /api/queries/:id(.:format)                              motor/queries#update
#                                        DELETE /api/queries/:id(.:format)                              motor/queries#destroy
#                         motor_api_tags GET    /api/tags(.:format)                                     motor/tags#index
#                      motor_api_configs GET    /api/configs(.:format)                                  motor/configs#index
#                                        POST   /api/configs(.:format)                                  motor/configs#create
#                    motor_api_resources GET    /api/resources(.:format)                                motor/resources#index
#                                        POST   /api/resources(.:format)                                motor/resources#create
#              motor_api_resource_method GET    /api/resource_methods/:resource(.:format)               motor/resource_methods#show
#       motor_api_resource_default_query GET    /api/resource_default_queries/:resource(.:format)       motor/resource_default_queries#show
#                 motor_api_schema_index GET    /api/schema(.:format)                                   motor/schema#index
#                       motor_api_schema GET    /api/schema/:resource(.:format)                         motor/schema#show
#                   motor_api_dashboards GET    /api/dashboards(.:format)                               motor/dashboards#index
#                                        POST   /api/dashboards(.:format)                               motor/dashboards#create
#                    motor_api_dashboard GET    /api/dashboards/:id(.:format)                           motor/dashboards#show
#                                        PATCH  /api/dashboards/:id(.:format)                           motor/dashboards#update
#                                        PUT    /api/dashboards/:id(.:format)                           motor/dashboards#update
#                                        DELETE /api/dashboards/:id(.:format)                           motor/dashboards#destroy
#              motor_api_run_api_request GET    /api/run_api_request(.:format)                          motor/run_api_requests#show
#                                        POST   /api/run_api_request(.:format)                          motor/run_api_requests#create
#          motor_api_run_graphql_request POST   /api/run_graphql_request(.:format)                      motor/run_graphql_requests#create
#                  motor_api_api_configs GET    /api/api_configs(.:format)                              motor/api_configs#index
#                                        POST   /api/api_configs(.:format)                              motor/api_configs#create
#                   motor_api_api_config DELETE /api/api_configs/:id(.:format)                          motor/api_configs#destroy
#                        motor_api_forms GET    /api/forms(.:format)                                    motor/forms#index
#                                        POST   /api/forms(.:format)                                    motor/forms#create
#                         motor_api_form GET    /api/forms/:id(.:format)                                motor/forms#show
#                                        PATCH  /api/forms/:id(.:format)                                motor/forms#update
#                                        PUT    /api/forms/:id(.:format)                                motor/forms#update
#                                        DELETE /api/forms/:id(.:format)                                motor/forms#destroy
#                        motor_api_notes GET    /api/notes(.:format)                                    motor/notes#index
#                                        POST   /api/notes(.:format)                                    motor/notes#create
#                         motor_api_note GET    /api/notes/:id(.:format)                                motor/notes#show
#                                        PATCH  /api/notes/:id(.:format)                                motor/notes#update
#                                        PUT    /api/notes/:id(.:format)                                motor/notes#update
#                                        DELETE /api/notes/:id(.:format)                                motor/notes#destroy
#                    motor_api_note_tags GET    /api/note_tags(.:format)                                motor/note_tags#index
# motor_api_users_for_autocomplete_index GET    /api/users_for_autocomplete(.:format)                   motor/users_for_autocomplete#index
#                motor_api_notifications GET    /api/notifications(.:format)                            motor/notifications#index
#                 motor_api_notification PATCH  /api/notifications/:id(.:format)                        motor/notifications#update
#                                        PUT    /api/notifications/:id(.:format)                        motor/notifications#update
#                    motor_api_reminders POST   /api/reminders(.:format)                                motor/reminders#create
#                     motor_api_reminder DELETE /api/reminders/:id(.:format)                            motor/reminders#destroy
#                       motor_api_alerts GET    /api/alerts(.:format)                                   motor/alerts#index
#                                        POST   /api/alerts(.:format)                                   motor/alerts#create
#                        motor_api_alert GET    /api/alerts/:id(.:format)                               motor/alerts#show
#                                        PATCH  /api/alerts/:id(.:format)                               motor/alerts#update
#                                        PUT    /api/alerts/:id(.:format)                               motor/alerts#update
#                                        DELETE /api/alerts/:id(.:format)                               motor/alerts#destroy
#                        motor_api_icons GET    /api/icons(.:format)                                    motor/icons#index
#   motor_api_active_storage_attachments POST   /api/data/active_storage__attachments(.:format)         motor/active_storage_attachments#create
#                       motor_api_audits GET    /api/audits(.:format)                                   motor/audits#index
#                      motor_api_session GET    /api/session(.:format)                                  motor/sessions#show
#                                        DELETE /api/session(.:format)                                  motor/sessions#destroy
#          motor_api_slack_conversations GET    /api/slack_conversations(.:format)                      motor/slack_conversations#index
#                                        PUT    /api/data/:resource/:resource_id/:method(.:format)      motor/data#execute {resource_id: /[^\/]+/}
#   motor_api_resource_association_index GET    /api/data/:resource/:resource_id/:association(.:format) motor/data#index {resource_id: /[^\/]+/}
#                                        POST   /api/data/:resource/:resource_id/:association(.:format) motor/data#create {resource_id: /[^\/]+/}
#                                        GET    /api/data/:resource(.:format)                           motor/data#index
#                                        POST   /api/data/:resource(.:format)                           motor/data#create
#                     motor_api_resource GET    /api/data/:resource/:id(.:format)                       motor/data#show {id: /[^\/]+/}
#                                        PATCH  /api/data/:resource/:id(.:format)                       motor/data#update {id: /[^\/]+/}
#                                        PUT    /api/data/:resource/:id(.:format)                       motor/data#update {id: /[^\/]+/}
#                                        DELETE /api/data/:resource/:id(.:format)                       motor/data#destroy {id: /[^\/]+/}
#                            motor_asset GET    /assets/:filename                                       motor/assets#show {filename: /.+/}
#                                  motor GET    /                                                       motor/ui#show
#                          motor_ui_data GET    /data(/*path)(.:format)                                 motor/ui#index
#                 motor_ui_notifications GET    /notifications(.:format)                                motor/ui#index
#                       motor_ui_reports GET    /reports(.:format)                                      motor/ui#index
#                        motor_ui_report GET    /reports/:id(.:format)                                  motor/ui#show
#                       motor_ui_queries GET    /queries(.:format)                                      motor/ui#index
#                     new_motor_ui_query GET    /queries/new(.:format)                                  motor/ui#new
#                         motor_ui_query GET    /queries/:id(.:format)                                  motor/ui#show
#                    motor_ui_dashboards GET    /dashboards(.:format)                                   motor/ui#index
#                 new_motor_ui_dashboard GET    /dashboards/new(.:format)                               motor/ui#new
#                     motor_ui_dashboard GET    /dashboards/:id(.:format)                               motor/ui#show
#                        motor_ui_alerts GET    /alerts(.:format)                                       motor/ui#index
#                     new_motor_ui_alert GET    /alerts/new(.:format)                                   motor/ui#new
#                         motor_ui_alert GET    /alerts/:id(.:format)                                   motor/ui#show
#                         motor_ui_forms GET    /forms(.:format)                                        motor/ui#index
#                      new_motor_ui_form GET    /forms/new(.:format)                                    motor/ui#new
#                          motor_ui_form GET    /forms/:id(.:format)                                    motor/ui#show
#
# Routes for MissionControl::Jobs::Engine:
#     application_queue_pause DELETE /applications/:application_id/queues/:queue_id/pause(.:format) mission_control/jobs/queues/pauses#destroy
#                             POST   /applications/:application_id/queues/:queue_id/pause(.:format) mission_control/jobs/queues/pauses#create
#          application_queues GET    /applications/:application_id/queues(.:format)                 mission_control/jobs/queues#index
#           application_queue GET    /applications/:application_id/queues/:id(.:format)             mission_control/jobs/queues#show
#       application_job_retry POST   /applications/:application_id/jobs/:job_id/retry(.:format)     mission_control/jobs/retries#create
#     application_job_discard POST   /applications/:application_id/jobs/:job_id/discard(.:format)   mission_control/jobs/discards#create
#    application_job_dispatch POST   /applications/:application_id/jobs/:job_id/dispatch(.:format)  mission_control/jobs/dispatches#create
#    application_bulk_retries POST   /applications/:application_id/jobs/bulk_retries(.:format)      mission_control/jobs/bulk_retries#create
#   application_bulk_discards POST   /applications/:application_id/jobs/bulk_discards(.:format)     mission_control/jobs/bulk_discards#create
#             application_job GET    /applications/:application_id/jobs/:id(.:format)               mission_control/jobs/jobs#show
#            application_jobs GET    /applications/:application_id/:status/jobs(.:format)           mission_control/jobs/jobs#index
#         application_workers GET    /applications/:application_id/workers(.:format)                mission_control/jobs/workers#index
#          application_worker GET    /applications/:application_id/workers/:id(.:format)            mission_control/jobs/workers#show
# application_recurring_tasks GET    /applications/:application_id/recurring_tasks(.:format)        mission_control/jobs/recurring_tasks#index
#  application_recurring_task GET    /applications/:application_id/recurring_tasks/:id(.:format)    mission_control/jobs/recurring_tasks#show
#                             PATCH  /applications/:application_id/recurring_tasks/:id(.:format)    mission_control/jobs/recurring_tasks#update
#                             PUT    /applications/:application_id/recurring_tasks/:id(.:format)    mission_control/jobs/recurring_tasks#update
#                      queues GET    /queues(.:format)                                              mission_control/jobs/queues#index
#                       queue GET    /queues/:id(.:format)                                          mission_control/jobs/queues#show
#                         job GET    /jobs/:id(.:format)                                            mission_control/jobs/jobs#show
#                        jobs GET    /:status/jobs(.:format)                                        mission_control/jobs/jobs#index
#                        root GET    /                                                              mission_control/jobs/queues#index
#
# Routes for PgHero::Engine:
#                     space GET  (/:database)/space(.:format)                     pg_hero/home#space
#            relation_space GET  (/:database)/space/:relation(.:format)           pg_hero/home#relation_space
#               index_bloat GET  (/:database)/index_bloat(.:format)               pg_hero/home#index_bloat
#              live_queries GET  (/:database)/live_queries(.:format)              pg_hero/home#live_queries
#                   queries GET  (/:database)/queries(.:format)                   pg_hero/home#queries
#                show_query GET  (/:database)/queries/:query_hash(.:format)       pg_hero/home#show_query
#                    system GET  (/:database)/system(.:format)                    pg_hero/home#system
#                 cpu_usage GET  (/:database)/cpu_usage(.:format)                 pg_hero/home#cpu_usage
#          connection_stats GET  (/:database)/connection_stats(.:format)          pg_hero/home#connection_stats
#     replication_lag_stats GET  (/:database)/replication_lag_stats(.:format)     pg_hero/home#replication_lag_stats
#                load_stats GET  (/:database)/load_stats(.:format)                pg_hero/home#load_stats
#          free_space_stats GET  (/:database)/free_space_stats(.:format)          pg_hero/home#free_space_stats
#                   explain GET  (/:database)/explain(.:format)                   pg_hero/home#explain
#                      tune GET  (/:database)/tune(.:format)                      pg_hero/home#tune
#               connections GET  (/:database)/connections(.:format)               pg_hero/home#connections
#               maintenance GET  (/:database)/maintenance(.:format)               pg_hero/home#maintenance
#                      kill POST (/:database)/kill(.:format)                      pg_hero/home#kill
# kill_long_running_queries POST (/:database)/kill_long_running_queries(.:format) pg_hero/home#kill_long_running_queries
#                  kill_all POST (/:database)/kill_all(.:format)                  pg_hero/home#kill_all
#        enable_query_stats POST (/:database)/enable_query_stats(.:format)        pg_hero/home#enable_query_stats
#                           POST (/:database)/explain(.:format)                   pg_hero/home#explain
#         reset_query_stats POST (/:database)/reset_query_stats(.:format)         pg_hero/home#reset_query_stats
#              system_stats GET  (/:database)/system_stats(.:format)              redirect(301, system)
#               query_stats GET  (/:database)/query_stats(.:format)               redirect(301, queries)
#                      root GET  /(:database)(.:format)                           pg_hero/home#index

