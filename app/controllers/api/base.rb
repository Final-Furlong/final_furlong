require "grape_logging"

module Api
  class Base < Grape::API
    logger.formatter = GrapeLogging::Formatters::Default.new
    insert_before Grape::Middleware::Error, GrapeLogging::Middleware::RequestLogger, { logger: } unless Rails.env.test?

    mount Api::V1::Base
  end
end

