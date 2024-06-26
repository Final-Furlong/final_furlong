module FinalFurlong
  module Internet
    module Validation
      class UrlValidator < ActiveModel::EachValidator
        def initialize(options)
          options.reverse_merge!(schemes: %w[http https])
          options.reverse_merge!(message: :invalid)
          options.reverse_merge!(allow_nil: false)
          options.reverse_merge!(allow_blank: false)

          super
        end

        def validate_each(record, attribute, value) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          return if value.nil? && options[:allow_nil]
          return if value.blank? && options[:allow_blank]

          uri = URI.parse(value)
          host = uri&.host
          scheme = uri&.scheme

          valid_url_regexp = scheme && value =~ /\A#{URI::DEFAULT_PARSER.make_regexp([scheme])}\z/
          valid_scheme = host && scheme && options[:schemes].include?(scheme)

          record.errors.add(attribute, options[:message], value:) unless valid_url_regexp && valid_scheme
        rescue URI::InvalidURIError
          record.errors.add(attribute, options[:message], value:)
        end
      end
    end
  end
end

