module Racing
  class JockeyBlueprint < Blueprinter::Base
    identifier :id

    fields :first_name, :last_name, :gender, :status,
      :height_in_inches, :weight, :jockey_type, :break_speed, :min_speed,
      :average_speed, :max_speed, :consistency, :fast, :good, :wet, :slow,
      :dirt, :turf, :steeplechase, :courage, :leading, :off_pace, :midpack, :closing,
      :pissy, :rating, :loaf_threshold, :acceleration, :traffic,
      :experience, :experience_rate, :turning, :strength, :looking, :whip_seconds

    field :date_of_birth do |jockey, options|
      I18n.l(jockey.date_of_birth, format: :default)
    end
  end
end

