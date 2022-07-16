module FinalFurlong
  module Common
    module Validation
      class DateValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.nil? && options[:allow_nil]
          return if value.blank? && options[:allow_blank]

          valid_date = strptime_date(value)
          return record.errors.add(attribute, :date_invalid, **{ value: }) unless valid_date
        end

        private

        def strptime_date(value)
          return value if value.is_a? Date

          Date.parse_safely(value)
        end
      end
    end
  end
end
