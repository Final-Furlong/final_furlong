module Horses
  class SearchStatusCount < BaseInteraction
    hash :query, default: {} do
      string :name_i_cont_all, default: nil
      string :gender_in, default: nil
      string :sire_name_i_cont_all, default: nil
      string :dam_name_i_cont_all, default: nil
      string :owner_name_i_cont_all, default: nil
      string :owner_name_eq, default: nil
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
      return if query["owner_name_eq"].blank? && query["owner_name_i_cont_all"].blank?

      @horse_query = if query["owner_name_eq"]
        horse_query.joins(:owner).where(owner: { name: query["owner_name_eq"] })
      else
        horse_query.joins(:owner).merge(Account::Stable.with_name(query["owner_name_i_cont_all"]))
      end
    end

    def set_breeder_name_query
      return if query["breeder_name_i_cont_all"].blank?

      @horse_query = horse_query.joins(:breeder).merge(Account::Stable.with_name(query["breeder_name_i_cont_all"]))
    end

    def set_min_age_name_query
      return if query["age_gteq"].blank?

      @horse_query = horse_query.where(horses: { age: query["age_gteq"].. })
    end

    def set_max_age_name_query
      return if query["age_lteq"].blank?

      @horse_query = horse_query.where(horses: { age: ..query["age_lteq"] })
    end

    def group_by_status_count
      list = {}
      horse_query.group(:type, :state).count.each do |group|
        type_info = group.first
        if type_info.first != "Horses::Horse::Foal"
          case type_info.last
          when "active"
            type = type_info.first.sub!("Horses::Horse::", "").downcase.to_sym
            list[type] ||= 0
            list[type] += group.last
          when "retired"
            list[:retired] ||= 0
            list[:retired] += group.last
          when "deceased"
            list[:deceased] ||= 0
            list[:deceased] += group.last
          else
            # do nothing, unborn
          end
        else
          case type_info.last
          when "active"
            list[:yearling] = horse_query.where(type: type_info.first).born.active.with_age(1).count
            list[:weanling] = horse_query.where(type: type_info.first).born.active.with_age(0).count
          when "deceased"
            list[:deceased] ||= 0
            list[:deceased] += group.last
          else
            # do nothing, unborn
          end
        end
      end
      list
    end

    def default_status_list
      set_default_query
      group_by_status_count
    end

    def set_default_query
      @horse_query = Horses::Horse.born
    end
  end
end

