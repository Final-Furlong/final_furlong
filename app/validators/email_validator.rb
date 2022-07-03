# typed: false

class EmailValidator < ActiveModel::EachValidator
  MAX_LENGTH = 254

  def initialize(options)
    options.reverse_merge!(format: { with: URI::MailTo::EMAIL_REGEXP })
    options.reverse_merge!(message: :invalid)

    super(options)
  end

  def validate_each(record, attribute, value)
    return if value.nil? && options[:allow_nil]
    return if value.blank? && options[:allow_blank]
    return record.errors.add(attribute, :too_long, count: MAX_LENGTH) if value && value.length > MAX_LENGTH

    # valid_email = EmailFormatValidationService.valid?(value)

    # record.errors.add(attribute, options[:message], value:) unless valid_email
  end
end
