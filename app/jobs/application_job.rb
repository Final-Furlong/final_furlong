class ApplicationJob < ActiveJob::Base
  # Don't retry job if record was deleted
  discard_on ActiveRecord::RecordNotFound
  discard_on ActiveJob::DeserializationError

  # Retry transient errors
  retry_on ActiveRecord::Deadlocked,
    wait: 5.seconds,
    attempts: 3

  retry_on Net::HTTPServerError,
    wait: :polynomially_longer,
    attempts: 10

  # Default catch-all (like Sidekiq)
  retry_on StandardError,
    wait: :exponentially_longer,
    attempts: 25

  # Logging
  before_perform do |job|
    Rails.logger.info "Starting #{job.class.name} with #{job.arguments}"
  end

  after_perform do |job|
    Rails.logger.info "Completed #{job.class.name}"
  end

  rescue_from(StandardError) do |exception|
    Rails.logger.error "Job failed: #{exception.message}"
    Rails.error.report(exception, handled: true, context: {
      job_class: self.class.name,
      job_id:,
      arguments:
    })
    raise # Re-raise to trigger retry
  end

  private

  def store_job_info(outcome:)
    JobStat.create!(name: self.class.name, last_run_at: Time.current, outcome:)
  end

  def run_today?
    JobStat.exists?(name: self.class.name, last_run_at: Date.current.all_day)
  end
end

