class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil? && options[:allow_nil]
    return if value.blank? && options[:allow_blank]

    date = value.is_a?(Date) ? value : Date.strptime_safely(value, "%d/%m/%Y")
    return record.errors.add(attribute, :date_invalid, **{ value: }) unless date
  end
end
