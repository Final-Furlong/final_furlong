module Horses
  class SearchStatusCount < BaseInteraction
    object :query, class: ActionController::Parameters

    attr_accessor :horse_query

    def execute
      return default_status_list if query.empty?

      build_query
      group_by_status_count
    end

    private

      def build_query
        set_default_query
        set_name_query
        set_gender_query
        set_sire_name_query
        set_dam_name_query
        set_owner_name_query
        set_min_age_name_query
        set_max_age_name_query
      end

      def set_name_query
        return if query[:name_i_cont_all].blank?

        @horse_query = horse_query.where("horses.name ILIKE ?", "%#{query[:name_i_cont_all]}%")
      end

      def set_gender_query
        return if query[:gender_in].blank?

        @horse_query = horse_query.where(gender: query[:gender_in].split(","))
      end

      def set_sire_name_query
        return if query[:sire_name_i_cont_all].blank?

        @horse_query = horse_query.joins(:sire).where("sires_horses.name ILIKE ?", "%#{query[:sire_name_i_cont_all]}%")
      end

      def set_dam_name_query
        return if query[:dam_name_i_cont_all].blank?

        @horse_query = horse_query.joins(:dam).where("dams_horses.name ILIKE ?", "%#{query[:dam_name_i_cont_all]}%")
      end

      def set_owner_name_query
        return if query[:owner_name_i_cont_all].blank?

        @horse_query = horse_query.joins(:owner).where("stables.name ILIKE ?", "%#{query[:owner_name_i_cont_all]}%")
      end

      def set_min_age_name_query
        return if query[:age_gteq].blank?

        @horse_query = horse_query.where("horses.age >= ?", query[:age_gteq])
      end

      def set_max_age_name_query
        return if query[:age_lteq].blank?

        @horse_query = horse_query.where("horses.age <= ?", query[:age_tteq])
      end

      def group_by_status_count
        horse_query.group(:status).count.symbolize_keys
      end

      def default_status_list
        set_default_query
        group_by_status_count
      end

      def set_default_query
        @horse_query = HorsesRepository.new.born
      end
  end
end

