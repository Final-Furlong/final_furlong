module Game
  class EclipseAward < ApplicationRecord
    CATEGORIES = %w[
      2yo_colt 2yo_filly 3yo_colt 3yo_filly older_horse older_mare sprinter classic endurance turf_horse turf_mare
      sc_colt sc_filly sc_horse sc_mare horse stable breeder sire
    ]
    self.table_name = "eclipse_awards"

    belongs_to :awardable, polymorphic: true

    delegate :name, to: :awardable, prefix: true

    scope :joins_awardable, ->(klass) {
      joins("INNER JOIN #{klass.table_name}
             ON #{table_name}.awardable_id = #{klass.table_name}.id")
        .where(awardable_type: klass.name)
    }
    scope :awardable_horse, ->(value) { where(awardable_id: id, awardable_type: "Horses::Horse") }
    scope :awardable_stable, ->(value) { where(awardable_id: id, awardable_type: "Account::Stable") }

    def self.ransackable_attributes(_auth_object = nil)
      %w[awardable_id awardable_type category year]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[awardable]
    end
  end
end

# == Schema Information
#
# Table name: eclipse_awards
# Database name: primary
#
#  id                                                                                                                                                                                 :bigint           not null, primary key
#  awardable_type                                                                                                                                                                     :string           indexed => [awardable_id, year], indexed => [awardable_id], indexed => [awardable_id]
#  category(2yo_colt,2yo_filly,3yo_colt,3yo_filly,older_horse,older_mare,sprinter,classic,endurance,turf_horse,turf_mare,sc_colt,sc_filly,sc_horse,sc_mare,horse,stable,breeder,sire) :enum             indexed => [year]
#  year                                                                                                                                                                               :integer          default(0), not null, indexed => [awardable_type, awardable_id], indexed, indexed => [category]
#  created_at                                                                                                                                                                         :datetime         not null
#  updated_at                                                                                                                                                                         :datetime         not null
#  awardable_id                                                                                                                                                                       :bigint           indexed => [awardable_type, year], indexed => [awardable_type], indexed => [awardable_type]
#
# Indexes
#
#  idx_on_awardable_type_awardable_id_year_e897327595       (awardable_type,awardable_id,year)
#  index_eclipse_awards_on_awardable                        (awardable_type,awardable_id)
#  index_eclipse_awards_on_awardable_type_and_awardable_id  (awardable_type,awardable_id)
#  index_eclipse_awards_on_year                             (year)
#  index_eclipse_awards_on_year_and_category                (year,category)
#

