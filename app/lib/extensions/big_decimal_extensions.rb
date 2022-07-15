class BigDecimal
  def in_instalments(number_of_instalments)
    return [] unless number_of_instalments
    return [] if number_of_instalments <= 0

    remainder = self % number_of_instalments
    instalment = (self - remainder) / number_of_instalments

    return [] if instalment.zero? && remainder.zero?

    result = [instalment + remainder]
    result += [instalment] * (number_of_instalments - 1) if instalment.positive?
    result
  end
end
