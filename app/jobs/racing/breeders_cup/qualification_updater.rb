class Racing::BreedersCup::QualificationUpdater < ApplicationJob
  queue_as :latency_30s

  def perform(class_name:)
    class_name.constantize.refresh
  end
end

