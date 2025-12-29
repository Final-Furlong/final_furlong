namespace :solid_queue do
  desc "Solid queue restart"
  task :restart do
    on roles(:app) do
      execute :sudo, "systemctl restart final-furlong-solid-queue"
    end
  end
end

