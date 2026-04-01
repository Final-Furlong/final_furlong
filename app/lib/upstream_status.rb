class UpstreamStatus
  STATUS_OK = "yes".freeze

  attr_accessor :primary_db, :legacy_db, :canary

  def is_ok
    primary_db == STATUS_OK and legacy_db == STATUS_OK and canary == STATUS_OK
  end
end

