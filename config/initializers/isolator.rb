if defined?(Isolator)
  Isolator.configure do |config|
    # Specify a custom logger to log offenses
    config.logger = Logger.new(Rails.root.join("log/isolator.log"))

    # Raise exception on offense
    config.raise_exceptions = false # true in test env

    # Send notifications to uniform_notifier
    config.send_notifications = false

    # Customize backtrace filtering (provide a callable)
    # By default, just takes the top-5 lines
    config.backtrace_filter = ->(backtrace) { backtrace.take(5) }

    # Define a custom ignorer class (must implement .prepare)
    # uses a row number based list from the .isolator_todo.yml file
    config.ignorer = Isolator::Ignorer

    # Turn on/off raising exceptions for simultaneous transactions to different databases
    config.disallow_per_thread_concurrent_transactions = false
  end
end

