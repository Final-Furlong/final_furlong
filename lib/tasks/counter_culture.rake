namespace :counter_culture do
  desc "Update counter culture values"
  task fix_counts: :environment do
    Horse.counter_culture_fix_counts
  end
end
