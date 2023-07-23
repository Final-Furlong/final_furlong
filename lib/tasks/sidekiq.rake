namespace :sidekiq do
  desc "Check the health of sidekiq queues"
  task health: :environment do
    critical = Sidekiq::Queue.new("critical").latency # 30s
    high = Sidekiq::Queue.new("high").latency # 5min
    default = Sidekiq::Queue.new("default").latency # 10min

    problems = {}
    problems[:critical] = critical if critical >= 30.seconds
    problems[:high] = high if high >= 5.minutes
    problems[:default] = default if default >= 10.minutes

    next if problems.empty?

    messages = []
    problems.each do |key, value|
      messages << "#{key.capitalize} queue latency: #{value}"
    end

    formatted_message = "Sidekiq is sad! #{messages.join(", ")}"
    raise StandardError, formatted_message
  end
end

