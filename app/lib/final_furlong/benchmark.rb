module FinalFurlong
  module Benchmark
    def measure_execution_time(identifier, tags = {})
      return unless block_given?

      result = nil

      ms = Benchmark.ms do
        result = yield
      end

      log_msg = "[Execution Time] identifier = #{identifier}, execution_time = #{ms} [ms]"
      if tags
        tags_str = tags.map { |k, v| "#{k}=#{v}" }.join(", ")
        log_msg += ", #{tags_str}"
      end

      Rails.logger.info log_msg
      puts log_msg # rubocop:disable Rails/Output

      result
    end

    module_function :measure_execution_time
  end
end

