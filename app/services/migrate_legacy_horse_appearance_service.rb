class MigrateLegacyHorseAppearanceService # rubocop:disable Metrics/ClassLength
  attr_reader :legacy_horse, :horse, :genetics

  def initialize(legacy_horse:)
    @legacy_horse = legacy_horse
    @horse = Horses::Horse.find_by(legacy_id: legacy_horse.id)
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return unless horse
    appearance = horse.appearance || Horses::Appearance.new(horse:)
    @genetics = horse.genetics || Horses::Genetics.new(horse:)
    genetics.allele = legacy_horse.Allele if legacy_horse.Allele.present?
    genetics.allele ||= generate_allele
    genetics.save if genetics.valid?

    current_height = [legacy_horse.CurrentHeight.to_f, birth_height.to_f].max
    return if pick_color.nil?
    appearance.assign_attributes(
      birth_height:,
      color: pick_color,
      current_height:,
      face_image: pick_face_image,
      face_marking: pick_face_marking,
      lf_leg_image: pick_leg_image("LF"),
      lf_leg_marking: pick_leg_marking("LF"),
      lh_leg_image: pick_leg_image("LH"),
      lh_leg_marking: pick_leg_marking("LH"),
      max_height: legacy_horse.Height.to_f,
      rf_leg_image: pick_leg_image("RF"),
      rf_leg_marking: pick_leg_marking("RF"),
      rh_leg_image: pick_leg_image("RH"),
      rh_leg_marking: pick_leg_marking("RH")
    )
    appearance.save!
  rescue => e
    Rails.logger.error "Legacy Info: #{legacy_horse.inspect}"
    Rails.logger.error "Info: #{horse.inspect}"
    raise e
  end

  private

  def birth_height
    height_in_inches = (legacy_horse.Height.to_f.floor * 4) + legacy_horse.Height.to_s.split(".").last.to_i
    birth_height_in_inches = legacy_horse.FoalHeight.nil? ? 0 : height_in_inches * legacy_horse.FoalHeight.fdiv(100).round(2)
    (birth_height_in_inches / 4).floor + (birth_height_in_inches % 4).fdiv(10).round(1)
  end

  def pick_color # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    case legacy_horse.color
    when 1 then "bay"
    when 2 then "black"
    when 3 then "blood_bay"
    when 4 then "blue_roan"
    when 5 then "brown"
    when 6 then "chestnut"
    when 7 then "dapple_grey"
    when 8 then "dark_bay"
    when 9 then "dark_grey"
    when 10 then "flea_bitten_grey"
    when 11 then "grey"
    when 12 then "light_bay"
    when 13 then "light_chestnut"
    when 14 then "light_grey"
    when 15 then "liver_chestnut"
    when 16 then "mahogany_bay"
    when 17 then "red_chestnut"
    when 18 then "strawberry_roan"
    else
      color = generate_color
      if color.blank? && legacy_horse.Sire.to_i.positive? && legacy_horse.Dam.to_i.positive?
        # puts legacy_horse.inspect
        raise StandardError, "Unexpected color: #{legacy_horse.Color}"
      end
      color
    end
  end

  def generate_allele
    sire_allele = Legacy::Horse.find_by(id: legacy_horse.Sire)&.Allele
    dam_allele = Legacy::Horse.find_by(id: legacy_horse.Dam)&.Allele
    return if sire_allele.blank? || dam_allele.blank?

    double_genes = []
    sire_allele[6, 8].chars.in_groups_of(4).each do |array|
      double_genes << [array.first(2).join(""), array.last(2).join("")]
    end
    sire_genes = sire_allele[0...6].chars.in_groups_of(2) + double_genes + sire_allele.chars.last(6).in_groups_of(2)
    double_genes = []
    dam_allele[6, 8].chars.in_groups_of(4).each do |array|
      double_genes << [array.first(2).join(""), array.last(2).join("")]
    end
    dam_genes = dam_allele[0...6].chars.in_groups_of(2) + double_genes + dam_allele.chars.last(6).in_groups_of(2)
    foal_allele = []
    sire_genes.each_with_index do |pair, index|
      gene1 = pair.sample
      gene2 = dam_genes[index].sample
      if gene1 > gene2
        foal_allele << dam_genes[index].sample
        foal_allele << pair.sample
      else
        foal_allele << pair.sample
        foal_allele << dam_genes[index].sample
      end
    end

    foal_allele.join("")
  end

  def generate_color
    allele = genetics.allele
    return if allele.blank?

    if allele.include?("G")
      if allele.include?("Fb")
        "flea_bitten_grey"
      elsif allele.include?("D")
        "dapple_grey"
      elsif allele.include?("ll")
        "dark_grey"
      elsif allele.include?("LL")
        "light_grey"
      else
        "grey"
      end
    elsif allele.include?("Rn")
      if allele.include?("ee")
        "strawberry_roan"
      else
        "blue_roan"
      end
    elsif allele.include?("E")
      "black"
    elsif allele.include?("A")
      if allele.include?("ll")
        "dark_bay"
      elsif allele.include?("LL")
        "light_bay"
      elsif allele.include?("Mb")
        "mahogany_bay"
      elsif allele.include?("Bl")
        "blood_bay"
      else
        "bay"
      end
    elsif allele.include?("ll")
      ["liver_chestnut", "brown"].sample
    elsif allele.include?("LL")
      ["light_chestnut", "red_chestnut"].sample
    else
      "chestnut"
    end
  end

  def pick_face_marking
    case legacy_horse.Face.to_i
    when 1 then "bald_face"
    when 2 then "blaze"
    when 3 then nil
    when 4 then "snip"
    when 5 then "star"
    when 6 then "star_snip"
    when 7 then "star_stripe"
    when 8 then "star_stripe_snip"
    when 9 then "stripe"
    when 10 then "stripe_snip"
    end
  end

  def pick_leg_marking(leg)
    case legacy_horse.send(:"#{leg}markings").to_i
    when 3 then nil
    when 11 then "coronet"
    when 12 then "ermine"
    when 13 then "sock"
    when 14 then "stocking"
    end
  end

  def pick_face_image
    case legacy_horse.FacePic.to_i
    when 15 then "stripe"
    when 16 then "star_stripe"
    when 17 then "star3"
    when 18 then nil
    when 19 then "blaze"
    when 20 then "star1"
    when 21 then "snip"
    when 22 then "star2"
    when 23 then "star_snip"
    when 24 then "star_stripe_snip"
    when 25 then "bald"
    when 26 then "stripe_snip"
    else
      case legacy_horse.Face.to_i
      when 1 then "bald_face"
      when 2 then "blaze"
      when 3 then nil
      when 4 then "snip"
      when 5 then ["star", "star2, start3"].sample
      when 6 then "star_snip"
      when 7 then "star_stripe"
      when 8 then "star_stripe_snip"
      when 9 then "stripe"
      when 10 then "stripe_snip"
      end
    end
  end

  def pick_leg_image(leg)
    case legacy_horse.send(:"#{leg}Pic").to_i
    when 18
      case legacy_horse.send(:"#{leg}markings").to_i
      when 11 then "coronet"
      when 12 then ["ermine1", "ermine2"].sample
      when 13 then ["sock1", "sock2"].sample
      when 14 then ["stocking1", "stocking2"].sample
      end
    when 27 then "coronet"
    when 28 then ["ermine1", "ermine2"].sample
    when 29 then "sock1"
    when 30 then "sock2"
    when 31, 32 then ["sock1", "sock2"].sample
    when 33 then "stocking1"
    when 34 then "stocking2"
    when 35 then ["stocking1", "stocking2"].sample
    else
      case legacy_horse.send(:"#{leg}markings").to_i
      when 11 then "coronet"
      when 12 then ["ermine1", "ermine2"].sample
      when 13 then ["sock1", "sock2"].sample
      when 14 then ["stocking1", "stocking2"].sample
      end
    end
  end
end

