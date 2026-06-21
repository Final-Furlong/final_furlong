module Racing
  class JockeySerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :gender, :status,
      :height_in_inches, :weight, :jockey_type, :break_speed, :min_speed,
      :average_speed, :max_speed, :consistency, :fast, :good, :wet, :slow,
      :dirt, :turf, :steeplechase, :courage, :leading, :off_pace, :midpack, :closing,
      :pissy, :rating, :loaf_threshold, :acceleration, :traffic,
      :experience, :experience_rate, :turning, :strength, :looking, :whip_seconds

    attribute :date_of_birth do
      I18n.l(object.date_of_birth, format: :default)
    end
  end
end

# == Schema Information
#
# Table name: jockeys
# Database name: primary
#
#  id                                   :bigint           not null, primary key
#  acceleration                         :integer          not null
#  average_speed                        :integer          not null
#  break_speed                          :integer          not null
#  closing                              :integer          not null
#  consistency                          :integer          not null
#  courage                              :integer          not null
#  date_of_birth                        :date             not null, indexed
#  dirt                                 :integer          not null
#  experience                           :integer          not null
#  experience_rate                      :integer          not null
#  fast                                 :integer          not null
#  first_name                           :string           not null, uniquely indexed => [last_name]
#  gender(male, female)                 :enum             indexed
#  good                                 :integer          not null
#  height_in_inches                     :integer          not null, indexed
#  jockey_type(flat, jump)              :enum             indexed
#  last_name                            :string           not null, uniquely indexed => [first_name], indexed
#  leading                              :integer          not null
#  loaf_threshold                       :integer          not null
#  looking                              :integer          not null
#  max_speed                            :integer          not null
#  midpack                              :integer          not null
#  min_speed                            :integer          not null
#  off_pace                             :integer          not null
#  pissy                                :integer          not null
#  rating                               :integer          not null
#  slow                                 :integer          not null
#  slug                                 :string           indexed
#  status(apprentice, veteran, retired) :enum             indexed
#  steeplechase                         :integer          not null
#  strength                             :integer          not null
#  traffic                              :integer          not null
#  turf                                 :integer          not null
#  turning                              :integer          not null
#  weight                               :integer          not null, indexed
#  wet                                  :integer          not null
#  whip_seconds                         :integer          not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  legacy_id                            :integer          not null, indexed
#  public_id                            :string(12)       indexed
#
# Indexes
#
#  index_jockeys_on_date_of_birth             (date_of_birth)
#  index_jockeys_on_first_name_and_last_name  (first_name,last_name) UNIQUE
#  index_jockeys_on_gender                    (gender)
#  index_jockeys_on_height_in_inches          (height_in_inches)
#  index_jockeys_on_jockey_type               (jockey_type)
#  index_jockeys_on_last_name                 (last_name)
#  index_jockeys_on_legacy_id                 (legacy_id)
#  index_jockeys_on_public_id                 (public_id)
#  index_jockeys_on_slug                      (slug)
#  index_jockeys_on_status                    (status)
#  index_jockeys_on_unique_name               (first_name, lower((last_name)::text)) UNIQUE
#  index_jockeys_on_weight                    (weight)
#

