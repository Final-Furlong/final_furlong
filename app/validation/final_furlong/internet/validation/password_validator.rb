module FinalFurlong
  module Internet
    module Validation
      class PasswordValidator < ActiveModel::EachValidator
        MIN_LENGTH = 8

        def validate_each(record, attribute, value) # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
          return if value.nil? && options[:allow_nil]
          return if value.blank? && options[:allow_blank]

          return record.errors.add(attribute, :too_short, count: MIN_LENGTH) if value && value.length < MIN_LENGTH

          valid_password = value && value =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^A-Za-z0-9]).{8,}$/

          record.errors.add(attribute, :weak, value:) unless valid_password
        end
      end
    end
  end
end
