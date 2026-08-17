module Horses
  class Horse::AlleleGenerator
    attr_reader :horse, :sire_allele, :dam_allele, :allele

    def initialize(horse)
      @horse = horse
      @sire_allele = horse.sire&.genetics&.allele
      @dam_allele = horse.dam&.genetics&.allele
    end

    def run
      return horse.genetics&.allele if horse.genetics&.allele.present?

      @allele = generate_allele
      Horses::Genetics.create!(horse: Horses::Horse.find(horse.id), allele:)
    end

    private

    def generate_allele
      [chestnut_genes, bay_genes, grey_genes, roan_genes, flea_bitten_genes, light_genes, mahogany_genes, blood_genes, dapple_genes, face_genes, white_genes].join("")
    end

    def white_genes
      sire_gene = sire_allele.blank? ? default_white_gene : sire_allele[rand(30..31), 1]
      dam_gene = dam_allele.blank? ? default_white_gene : dam_allele[rand(30..31), 1]
      normalize_gene(type: :white, gene: [sire_gene, dam_gene].join(""))
    end

    def face_genes
      sire_gene = sire_allele.blank? ? default_face_gene : sire_allele[rand(28..29), 1]
      dam_gene = dam_allele.blank? ? default_face_gene : dam_allele[rand(28..29), 1]
      normalize_gene(type: :face, gene: [sire_gene, dam_gene].join(""))
    end

    def dapple_genes
      sire_grey = sire_allele.blank? ? default_grey_gene : sire_allele[rand(4..5), 1]
      dam_grey = dam_allele.blank? ? default_grey_gene : dam_allele[rand(4..5), 1]
      sire_gene = sire_allele.blank? ? default_dapple_gene(sire_grey.include?("G")) : sire_allele[rand(26..27), 1]
      dam_gene = dam_allele.blank? ? default_dapple_gene(dam_grey.include?("G")) : dam_allele[rand(26..27), 1]
      normalize_gene(type: :dapple, gene: [sire_gene, dam_gene].join(""))
    end

    def blood_genes
      sire_gene = sire_allele.blank? ? default_blood_gene : sire_allele[rand(22..24), 2]
      dam_gene = dam_allele.blank? ? default_blood_gene : dam_allele[rand(22..24), 2]
      normalize_gene(type: :blood, gene: [sire_gene, dam_gene].join(""))
    end

    def mahogany_genes
      sire_gene = sire_allele.blank? ? default_mahogany_gene : sire_allele[rand(18..20), 2]
      dam_gene = dam_allele.blank? ? default_mahogany_gene : dam_allele[rand(18..20), 2]
      normalize_gene(type: :mahogany, gene: [sire_gene, dam_gene].join(""))
    end

    def light_genes
      sire_gene = sire_allele.blank? ? default_light_gene : sire_allele[rand(14..16), 2]
      dam_gene = dam_allele.blank? ? default_light_gene : dam_allele[rand(14..16), 2]
      normalize_gene(type: :light, gene: [sire_gene, dam_gene].join(""))
    end

    def flea_bitten_genes
      sire_gene = sire_allele.blank? ? default_flea_bitten_gene : sire_allele[rand(10..12), 2]
      dam_gene = dam_allele.blank? ? default_flea_bitten_gene : dam_allele[rand(10..12), 2]
      normalize_gene(type: :flea_bitten, gene: [sire_gene, dam_gene].join(""))
    end

    def roan_genes
      sire_gene = sire_allele.blank? ? default_roan_gene : sire_allele[rand(6..8), 2]
      dam_gene = dam_allele.blank? ? default_roan_gene : dam_allele[rand(6..8), 2]
      normalize_gene(type: :roan, gene: [sire_gene, dam_gene].join(""))
    end

    def grey_genes
      sire_gene = sire_allele.blank? ? default_grey_gene : sire_allele[rand(4..5), 1]
      dam_gene = dam_allele.blank? ? default_grey_gene : dam_allele[rand(4..5), 1]
      normalize_gene(type: :grey, gene: [sire_gene, dam_gene].join(""))
    end

    def chestnut_genes
      sire_gene = sire_allele.blank? ? default_chestnut_gene : sire_allele[rand(0..1), 1]
      dam_gene = dam_allele.blank? ? default_chestnut_gene : dam_allele[rand(0..1), 1]
      normalize_gene(type: :chestnut, gene: [sire_gene, dam_gene].join(""))
    end

    def bay_genes
      sire_bay = sire_allele.blank? ? default_bay_gene : sire_allele[rand(2..3), 1]
      dam_bay = dam_allele.blank? ? default_bay_gene : dam_allele[rand(2..3), 1]
      normalize_gene(type: :bay, gene: [sire_bay, dam_bay].join(""))
    end

    def normalize_gene(type:, gene:)
      case type
      when :bay
        (gene == "aA") ? "Aa" : gene
      when :chestnut
        (gene == "eE") ? "Ee" : gene
      when :grey
        (gene == "gG") ? "Gg" : gene
      when :roan
        (gene == "rnRn") ? "Rnrn" : gene
      when :flea_bitten
        (gene == "fbFb") ? "Fbfb" : gene
      when :light
        (gene == "lL") ? "Ll" : gene
      when :mahogany
        (gene == "mbMb") ? "Mbmb" : gene
      when :blood
        (gene == "blBl") ? "Blbl" : gene
      when :dapple
        (gene == "dD") ? "Dd" : gene
      when :face
        (gene == "fF") ? "Ff" : gene
      when :white
        (gene == "wW") ? "Ww" : gene
      end
    end

    def default_bay_gene
      (rand(1..4) == 1) ? "A" : "a"
    end

    def default_chestnut_gene
      (rand(1..4) == 1) ? "E" : "e"
    end

    def default_grey_gene
      (rand(1..4) == 1) ? "G" : "g"
    end

    def default_roan_gene
      (rand(1..4) == 1) ? "Rn" : "rn"
    end

    def default_flea_bitten_gene
      (rand(1..4) == 1) ? "Fb" : "fb"
    end

    def default_light_gene
      (rand(1..5) == 1) ? "L" : "l"
    end

    def default_mahogany_gene
      (rand(1..10) == 1) ? "Mb" : "mb"
    end

    def default_blood_gene
      (rand(1..8) == 1) ? "Bl" : "bl"
    end

    def default_dapple_gene(grey)
      return "d" unless grey

      (rand(1..2) == 1) ? "D" : "d"
    end

    def default_face_gene
      (rand(1..4) == 1) ? "F" : "f"
    end

    def default_white_gene
      (rand(1..4) == 1) ? "W" : "w"
    end

    def color(chestnut, bay, grey, roan, flea_bitten, light, mahogany, blood, dapple, face, white)
      if grey.include?("G")
        if flea_bitten.include?("Fb")
          "Flea-bitten grey"
        elsif dapple.include?("D")
          "Dapple grey"
        elsif light == "ll"
          "Dark grey"
        else
          "Light grey"
        end
      elsif roan.include?("Rn")
        if chestnut == "ee"
          "Strawberry roan"
        else
          "Blue roan"
        end
      elsif chestnut.include?("E")
        if bay.include?("A")
          if light == "ll"
            "Dark bay"
          elsif light == "LL"
            "Light bay"
          elsif mahogany.include?("Mb")
            "Mahogany bay"
          elsif blood.include?("Bl")
            "Blood bay"
          else
            "Bay"
          end
        else
          "Black"
        end
      elsif light == "ll"
        (rand(0..1) == 1) ? "Liver chestnut" : "Brown"
      elsif light == "LL"
        (rand(0..1) == 1) ? "Light chestnut" : "Red chestnut"
      else
        "Chestnut"
      end
    end
  end
end

