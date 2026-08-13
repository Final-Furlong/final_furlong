module Horses
  class Horse::AppearanceGenerator
    attr_reader :horse, :allele, :face, :lf, :lh, :rf, :rh

    class MissingAlleleError < StandardError; end

    def initialize(horse)
      @horse = horse
      @allele = horse.genetics&.allele
      raise MissingAlleleError, "Missing allele for horse #{horse.id}" if allele.blank?
    end

    def run
      return horse.appearance if horse.appearance

      @face = pick_face_markings
      @lf = pick_leg_marking
      @lh = pick_leg_marking
      @rf = pick_leg_marking
      @rh = pick_leg_marking
      birth_height = generate_birth_height
      Horses::Appearance.create!(
        horse: Horses::Horse.find(horse.id),
        color: pick_color,
        face_marking: face,
        face_image: pick_face_image,
        lf_leg_marking: lf,
        lh_leg_marking: lh,
        rf_leg_marking: rf,
        rh_leg_marking: rh,
        lf_leg_image: pick_leg_image(:lf),
        lh_leg_image: pick_leg_image(:lh),
        rf_leg_image: pick_leg_image(:rf),
        rh_leg_image: pick_leg_image(:rh),
        birth_height:,
        current_height: birth_height,
        max_height: generate_max_height
      )
      Horses::GrowHorseJob.perform_later(id: horse.id)
    end

    private

    def generate_max_height
      sire = Horses::Horse.find_by(id: horse.sire_id)
      dam = Horses::Horse.find_by(id: horse.dam_id)
      sire_height = height_to_inches(sire&.appearance&.max_height)
      dam_height = height_to_inches(dam&.appearance&.max_height)
      height_inches = rand([sire_height, dam_height].min..[sire_height, dam_height].max)
      "#{height_inches / 4}.#{height_inches % 4}".to_f
    end

    def height_to_inches(height)
      return generate_random_height if height.blank?

      hands, inches = height.to_s.split(".")
      (hands.to_i * 4) + inches.to_i
    end

    def generate_random_height
      rand(60..70)
    end

    def generate_birth_height
      birth_inches = rand(32..44)
      "#{birth_inches / 4}.#{birth_inches % 4}".to_f
    end

    def pick_leg_image(type)
      marking = send(type)
      case marking
      when "stocking"
        %w[stocking1 stocking2].sample
      when "sock"
        %w[sock1 sock2].sample
      when "ermine"
        %w[ermine1 ermine2].sample
      else
        marking
      end
    end

    def pick_leg_marking
      white_allele = allele[28, 2]
      case white_allele
      when "WW"
        [nil, "stocking", "stocking", "stocking", "sock", "sock"].sample
      when "ww"
        [nil, nil, nil, "coronet", "ermine"].sample
      else
        [nil, nil, "coronet", "coronet", "sock", "sock", "sock", "stocking"].sample
      end
    end

    def pick_face_image
      case face
      when "star"
        %w[star star1 star2 star3].sample
      when "bald_face"
        "bald"
      else
        face
      end
    end

    def pick_face_markings
      face_allele = allele[26, 2]
      @face = if face_allele == "FF"
        %w[bald_face blaze star_stripe_snip].sample
      elsif face_allele == "ff"
        ["snip", "star", "stripe", nil].sample
      else
        %w[star_snip star_stripe stripe_snip].sample
      end
    end

    def pick_color
      chestnut = allele[0, 2]
      bay = allele[2, 2]
      grey = allele[4, 2]
      roan = allele[6, 4]
      flea_bitten = allele[10, 4]
      light = allele[14, 2]
      mahogany = allele[16, 4]
      blood = allele[20, 4]
      dapple = allele[24, 2]
      face = allele[26, 2]
      white = allele[28, 2]
      color(chestnut, bay, grey, roan, flea_bitten, light, mahogany, blood, dapple, face, white)
    end

    def color(chestnut, bay, grey, roan, flea_bitten, light, mahogany, blood, dapple, face, white)
      if grey.include?("G")
        if flea_bitten.include?("Fb")
          "flea_bitten_grey"
        elsif dapple.include?("D")
          "dapple_grey"
        elsif light == "ll"
          "dark_grey"
        else
          "light_grey"
        end
      elsif roan.include?("Rn")
        if chestnut == "ee"
          "strawberry_roan"
        else
          "blue_roan"
        end
      elsif chestnut.include?("E")
        if bay.include?("A")
          if light == "ll"
            "dark_bay"
          elsif light == "LL"
            "light_bay"
          elsif mahogany.include?("Mb")
            "mahogany_bay"
          elsif blood.include?("Bl")
            "blood_bay"
          else
            "bay"
          end
        else
          "black"
        end
      elsif light == "ll"
        (rand(0..1) == 1) ? "liver_chestnut" : "brown"
      elsif light == "LL"
        (rand(0..1) == 1) ? "light_chestnut" : "red_chestnut"
      else
        "chestnut"
      end
    end
  end
end

