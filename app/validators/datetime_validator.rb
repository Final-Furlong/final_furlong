# typed: false

class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value) # rubocop:disable Metrics/CyclomaticComplexity
    return if value.nil? && options[:allow_nil]
    return if value.blank? && options[:allow_blank]

    valid_time = case value
                 when String
                   DateTime.parse_safely(value)
                 when Time, DateTime
                   value
                 end

    return record.errors.add(attribute, :datetime_invalid, **{ value: }) unless valid_time
  end
end
