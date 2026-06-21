ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  gc_stats = GC.stat

  unless Rails.env.local?
    Rails.logger.info(
      gc_time_ms: gc_stats[:time] || 0,
      gc_major_count: gc_stats[:major_gc_count],
      gc_minor_count: gc_stats[:minor_gc_count],
      heap_slots: gc_stats[:heap_available_slots],
      request_path: event.payload[:path],
      duration_ms: event.duration.round(1)
    )
  end
end

