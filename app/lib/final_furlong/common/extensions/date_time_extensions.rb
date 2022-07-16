module FinalFurlong
  module Common
    class DateTime
      def reset_date_part
        Time.zone.local(1970, 1, 1, hour, min, second, zone)
      end

      def self.parse_safely(value)
        DateTime.parse(value)
      rescue StandardError
        nil
      end
    end

    class Time
      def reset_date_part
        Time.zone.local(1970, 1, 1, hour, min, sec, gmtoff).in_time_zone
      end
    end
  end
end
