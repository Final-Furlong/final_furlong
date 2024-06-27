if defined?(PutsDebuggerer) && Rails.env.local?
  PutsDebuggerer.app_path = Rails.root.to_s
end

unless Rails.env.local?
  def pd(*args, &block)
    # `pd(...)` in Ruby 2.7+
    # No Op (just a stub in case developers forget troubleshooting pd calls in the code and deploy to production)
  end
end

