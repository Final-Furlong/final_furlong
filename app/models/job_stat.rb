class JobStat < ApplicationRecord
  scope :recent, -> { order(last_run_at: :desc) }
end

# == Schema Information
#
# Table name: job_stats
# Database name: primary
#
#  id          :bigint           not null, primary key
#  last_run_at :datetime         indexed
#  name        :string           not null, indexed
#  outcome     :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_job_stats_on_last_run_at  (last_run_at)
#  index_job_stats_on_name         (name)
#

