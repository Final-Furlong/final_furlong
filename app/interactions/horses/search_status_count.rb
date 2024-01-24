module Horses
  class SearchStatusCount < BaseInteraction
    hash :query, default: {} do
      string :name_i_cont_all, default: nil
      string :gender_in, default: nil
      string :sire_name_i_cont_all, default: nil
      string :dam_name_i_cont_all, default: nil
      string :owner_name_i_cont_all, default: nil
      string :breeder_name_i_cont_all, default: nil
      string :age_gteq, default: nil
      string :age_lteq, default: nil
    end

    attr_accessor :horse_query, :stable_query

    def execute
      return default_status_list if query.empty?

      build_query
      group_by_status_count
    end

    private

    def build_query
      @stable_query = ::Account::StablesQuery
      set_default_query
      set_name_query
      set_gender_query
      set_sire_name_query
      set_dam_name_query
      set_owner_name_query
      set_breeder_name_query
      set_min_age_name_query
      set_max_age_name_query
    end

    def set_name_query
      return if query["name_i_cont_all"].blank?

      @horse_query = horse_query.where("horses.name ILIKE ?", "%#{query["name_i_cont_all"]}%")
    end

    def set_gender_query
      return if query["gender_in"].blank?

      @horse_query = horse_query.where(gender: query["gender_in"].split(","))
    end

    def set_sire_name_query
      return if query["sire_name_i_cont_all"].blank?

      @horse_query = horse_query.joins(:sire)
        .where("sires_horses.name ILIKE ?", "%#{query["sire_name_i_cont_all"]}%")
    end

    def set_dam_name_query
      return if query["dam_name_i_cont_all"].blank?

      @horse_query = horse_query.joins(:dam)
        .where("dams_horses.name ILIKE ?", "%#{query["dam_name_i_cont_all"]}%")
    end

    def set_owner_name_query
      return if query["owner_name_i_cont_all"].blank?

      stables = stable_query.name_includes(query["owner_name_i_cont_all"])
      @horse_query = horse_query.joins(:owner).where(owner: stables)
    end

    def set_breeder_name_query
      return if query["breeder_name_i_cont_all"].blank?

      stables = stable_query.name_includes(query["breeder_name_i_cont_all"])
      @horse_query = horse_query.joins(:breeder).where(breeder: stables)
    end

    def set_min_age_name_query
      return if query["age_gteq"].blank?

      @horse_query = horse_query.where("horses.age >= ?", query["age_gteq"])
    end

    def set_max_age_name_query
      return if query["age_lteq"].blank?

      @horse_query = horse_query.where("horses.age <= ?", query["age_lteq"])
    end

    def group_by_status_count
      horse_query.group(:status).count.symbolize_keys
    end

    def default_status_list
      set_default_query
      group_by_status_count
    end

    def set_default_query
      @horse_query = HorsesQuery.new.born
    end
  end
end

