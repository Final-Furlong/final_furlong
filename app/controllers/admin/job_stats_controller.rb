module Admin
  class JobStatsController < AdminController
    def index
      authorize :job_stats, :index?

      Zeitwerk::Loader.eager_load_all
      @classes = ApplicationJob.descendants.collect(&:name).reject { |klass|
        klass.start_with?("Sentry::")
      }.sort
    end
  end
end

