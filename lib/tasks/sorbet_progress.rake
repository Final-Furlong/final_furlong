# typed: false

namespace :srb do
  desc "Run sorbet and display progress stats"
  task progress: :environment do
    # require "sorbet"
    # require "sorbet-progress"

    system("bundle exec srb tc --metrics-file tmp/sorbet_metrics.json")
    system("bundle exec sorbet_progress tmp/sorbet_metrics.json")
  end
end
