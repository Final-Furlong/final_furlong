authenticate :user, lambda { |user| user.admin? } do
  mount GoodJob::Engine => "/jobs"
  mount PgHero::Engine, at: "/pghero"

  namespace :admin do
    resource :impersonate, only: %i[create destroy]
    resources :job_stats, only: :index
    scope module: :horses, as: "horses" do
      resources :horses, only: [] do
        member do
          resource :owner, only: %i[edit update]
        end
      end
    end
  end
end

