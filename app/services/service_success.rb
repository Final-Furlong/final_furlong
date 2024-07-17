class ServiceSuccess
  attr_reader :payload

  def initialize(payload = nil)
    @payload = payload
  end

  def success?
    true
  end

  def to_s
    @payload
  end
end

