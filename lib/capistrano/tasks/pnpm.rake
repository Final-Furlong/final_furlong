namespace :pnpm do
  desc "Install JavaScript dependencies using pnpm"
  task :install do
    on roles(fetch(:pnpm_roles, :web)) do
      within release_path do
        with fetch(:pnpm_env, {}) do
          flags = Array(fetch(:pnpm_flags, %w[--frozen-lockfile]))
          execute :pnpm, :install, *flags
        end
      end
    end
  end
end

