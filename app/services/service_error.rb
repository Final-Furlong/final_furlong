class ServiceError
  attr_reader :error

  def initialize(error = nil)
    @error = error
  end

  def success?
    false
  end

  def to_s
    @error
  end
end

