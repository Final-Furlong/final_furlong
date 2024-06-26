PutsDebuggerer.app_path = Rails.root.to_s

unless Rails.env.development? || Rails.env.test?
  def pd(*args, &block)
    # `pd(...)` in Ruby 2.7+
    # No Op (just a stub in case developers forget troubleshooting pd calls in the code and deploy to production)
  end
end

