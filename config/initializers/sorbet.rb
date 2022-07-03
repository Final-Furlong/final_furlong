# Disable sorbet-runtime in production
T::Configuration.call_validation_error_handler = lambda do |signature, opts|
  raise TypeError, opts[:pretty_message] unless signature.on_failure && signature.on_failure[0] == :log

  Rails.logger.tagged("sorbet") { Rails.logger.error opts[:pretty_message] }
end
