namespace :pnpm do
  desc "Install JavaScript dependencies using pnpm"
  task :install do
    as user: 'www', group: 'www' do
      within release_path do
        flags = Array(fetch(:pnpm_flags, %w[--frozen-lockfile --prod]))
        execute :pnpm, :install, *flags
      end
    end
  end
end

