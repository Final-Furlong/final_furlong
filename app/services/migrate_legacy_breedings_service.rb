class MigrateLegacyBreedingsService
  def call
    min_id = Horses::Breeding.maximum(:legacy_id) || 0
    Legacy::Breeding.where("ID > ?", min_id).find_each do |legacy_breeding|
      mare = Horses::Horse.find_by(legacy_id: legacy_breeding.Mare)
      stud = Horses::Horse.find_by(legacy_id: legacy_breeding.Stud)
      next unless mare&.broodmare?
      next unless stud&.stud? || stud&.retired_stud?

      date = legacy_breeding.Date - 4.years
      breeding = Horses::Breeding.find_or_initialize_by(mare:, stud:, year: date.year)
      breeding.date = date
      breeding.status = case legacy_breeding.Status.to_s
      when "A"
        "approved"
      when "D"
        "denied"
      else
        "pending"
      end
      breeding.fee = legacy_breeding.CustomFee
      if legacy_breeding.Due.present?
        breeding.status = "bred"
        breeding.due_date = legacy_breeding.Due - 4.years
      end
      breeding.legacy_id = legacy_breeding.ID
      breeding.save!
    end
  end
end

