class MigrateLegacyBreedingStatsService
  def call
    min_id = Horses::Horse.where.associated(:breeding_stats).maximum(:legacy_id) || 0
    Horses::Horse.where.missing(:breeding_stats).where("legacy_id > ?", min_id).find_each do |horse|
      next if horse.gelding? && horse.stud_foals.blank?
      next if horse.female? && horse.status == "retired" && horse.foals.blank?

      stats = horse.breeding_stats || horse.build_breeding_stats
      legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
      next unless legacy_horse

      stats.breeding_potential = legacy_horse.BPF
      stats.breeding_potential_grandparent = legacy_horse.BMBPF
      stats.soundness = legacy_horse.GenSound || legacy_horse.Soudness
      stats.dosage = legacy_horse.DC
      next unless stats.valid?

      stats.save
    end
  end
end

