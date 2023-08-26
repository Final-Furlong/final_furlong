module FinalFurlong
  module Common
    module Validation
      class DatetimeValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.nil? && options[:allow_nil]
          return if value.blank? && options[:allow_blank]

          valid_time = parse_time(value)

          return record.errors.add(attribute, :datetime_invalid, value:) unless valid_time
        end

        private

        def parse_time(value)
          return value if value.is_a?(Time) || value.is_a?(DateTime)

          DateTime.parse_safely(value)
        end
      end
    end
  end
end

