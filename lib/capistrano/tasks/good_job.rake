namespace :good_job do
  desc "Start good job background process"
  task :start do
    on roles(:web) do
      execute "systemctl --user start final_furlong_good_job_#{fetch(:rails_env).to_s.downcase}.service"
    end
  end

  desc "Restart good job background process"
  task :restart do
    on roles(:web) do
      execute "systemctl --user restart final_furlong_good_job_#{fetch(:rails_env).to_s.downcase}.service"
    end
  end

  desc "Stop good job background process"
  task :stop do
    on roles(:web) do
      execute "systemctl --user stop final_furlong_good_job_#{fetch(:rails_env).to_s.downcase}.service"
    end
  end
end

