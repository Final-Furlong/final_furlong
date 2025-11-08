class MigrateLegacyLeasesService # rubocop:disable Metrics/ClassLength
  def call(id)
    legacy_lease = Legacy::Lease.find_by(ID: id)
    horse = Horses::Horse.find_by(legacy_id: legacy_lease.horse)
    return unless horse

    owner = Account::Stable.find_by(legacy_id: legacy_lease.owner)
    return unless owner

    leaser = Account::Stable.find_by(legacy_id: legacy_lease.leaser)
    return unless leaser

    start_date = legacy_lease.Start - 4.years

    lease = Horses::Lease.find_or_initialize_by(horse:, start_date:)
    lease.update!(
      owner:,
      leaser:,
      fee: legacy_lease.Fee.to_i,
      end_date: legacy_lease.End - 4.years,
      active: legacy_lease.Active,
      early_termination_date: legacy_lease.Terminated.blank? ? nil : legacy_lease.Terminated - 4.years,
      created_at: start_date
    )
  end
end

