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

