class MigrateLegacyStallionOptionsService
  def call
    Legacy::Horse.where(Status: 7).find_each do |legacy_stud|
      stud = Horses::Horse.find_by(legacy_id: legacy_stud.ID)
      next unless stud&.stud?

      options = stud.stud_options || stud.build_stud_options
      options.stud_fee = legacy_stud.StudPrice
      options.outside_mares_allowed = legacy_stud.Outside || 0
      options.outside_mare_per_stable = legacy_stud.MaresPerStable || 0
      options.approval_required = legacy_stud.Approval
      options.breed_to_game_mares = legacy_stud.FFMares
      options.save!
    end
  end
end

