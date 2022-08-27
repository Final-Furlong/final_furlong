if defined?(DatabaseCleaner)
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean
end

CypressOnRails::SmartFactoryWrapper.reload

if defined?(VCR)
  VCR.eject_cassette # make sure we no cassette inserted before the next test starts
  VCR.turn_off!
  WebMock.disable! if defined?(WebMock)
end

Rails.logger.info "APPCLEANED" # used by log_fail.rb

