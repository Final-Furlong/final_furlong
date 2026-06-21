module Racing
  class JockeySerializer < ActiveModel::Serializer
    attributes :id, :email

    attributes :first_name, :last_name, :gender, :status, :date_of_birth,
      :height_in_inches, :weight, :jockey_type, :break_speed, :min_speed,
      :average_speed, :max_speed, :consistency, :fast, :good, :wet, :slow,
      :dirt, :turf, :steeplechase, :courage, :leading, :off_pace, :midpack, :closing,
      :pissy, :rating, :loat_threshold, :acceleration, :traffic,
      :experience, :experience_rate, :turning, :strength, :looking, :whip_seconds
  end
end

