namespace :horses, module: "horses" do
  resources :lease_offers, only: :index
  resources :sale_offers, only: :index
end

resources :horses, except: %i[new create destroy] do
  scope module: :horse do
    resources :boardings, only: %i[index new create destroy]
    resources :future_races, except: :new
    get "future_races/:race_id/new", to: "future_races#new", as: :new_future_race
    resources :mare_bookings, except: :show do
      collection do
        get "/month_dependent_fields/:stud_id", to: "mare_bookings#month_dependent_fields", as: :month_dependent_fields
      end
    end
    get "mare_bookings/pick_date", to: "mare_bookings#pick_date", as: :mare_bookings_pick_date
    get "mare_bookings/request_booking", to: "mare_bookings#request_booking", as: :mare_bookings_request_booking
    resources :stud_bookings do
      collection do
        get "/stable_dependent_fields/:stable_id/:slot_id", to: "stud_bookings#stable_dependent_fields", as: :stable_dependent_fields
      end
    end
  end
  member do
    get :image
    get :thumbnail
    get :edit_name
    get "foal/:booking_id", to: "horse/foals#new", as: :new_foal
    post "foal/:booking_id", to: "horse/foals#create", as: :foal
    scope module: :horse, as: "horse" do
      resource :auction_consignment, only: %i[new create]
      resources :events, only: :index
      resources :entries, only: :index
      resources :foals, only: :index
      resources :images, only: :index
      resources :injuries, only: :index
      resources :jockeys, only: :index
      resources :jump_trials, only: %i[index new create]
      resource :lease_offer, only: %i[new create destroy]
      resource :lease_offer_acceptance, only: :create
      resource :lease_termination, only: %i[new create]
      resource :owner, only: %i[update]
      resource :stud_nonimation, only: %i[new create]
      resources :stud_nominations, only: :index
      resource :pedigree, only: :show
      resource :race_options, only: %i[edit update]
      resources :race_stats, only: %i[index]
      resources :races, only: :index
      resource :specific_race_record, only: :show
      resource :sale_offer, only: %i[new create destroy]
      resource :sale_offer_acceptance, only: :create
      resources :sales, only: :index
      resources :shipments, only: %i[index new create] do
        get :destination_dependent_fields, on: :collection
      end
      resource :status, only: %i[edit update]
      resource :stud_options, only: %i[new create edit update]
      resources :workouts, only: %i[index new create]
      resources :workout_stats, only: %i[index]
    end
    delete "shipments/:shipment_id", to: "horse/shipments#destroy", as: :shipment
  end
end

resources :auctions do
  scope module: "auctions" do
    resources :horses, except: :index do
      resources :bids, only: %i[new create]
    end
  end
end

