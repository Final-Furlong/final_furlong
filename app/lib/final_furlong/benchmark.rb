module FinalFurlong
  module Benchmark
    def measure_execution_time(identifier, tags = {})
      return unless block_given?

      start_time = Time.current

      result = yield

      end_time = Time.current
      seconds = (end_time - start_time)

      log_msg = "[Execution Time] identifier = #{identifier}, execution_time = #{seconds} [s]"
      if tags
        tags_str = tags.map { |k, v| "#{k}=#{v}" }.join(", ")
        log_msg += ", #{tags_str}"
      end

      Rails.logger.info log_msg

      result
    end

    module_function :measure_execution_time
  end
end

