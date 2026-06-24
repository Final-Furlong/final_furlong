class Yearly::StartOfYearJob < ApplicationJob
  queue_as :latency_30s

  def perform
    return if run_today?

    classes = []
    class_list.each do |job_class|
      classes << job_class.to_s
      job_class.perform_later
    end

    store_job_info(outcome: { classes: classes.count })
  end

  def class_list
    [Horses::UpdateAgesJob]
  end
end

