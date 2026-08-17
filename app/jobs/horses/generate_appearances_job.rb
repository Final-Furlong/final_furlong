class Horses::GenerateAppearancesJob < ApplicationJob
  queue_as :latency_5m

  def perform
    return if run_today?

    genetics = 0
    appearances = 0
    Horses::Horse.where.missing(:genetics).find_each do |horse|
      horse.generate_allele
      horse.reload
      horse.generate_appearance
      genetics += 1
      appearances + 1
    end

    Horses::Horse.where.associated(:genetics).where.missing(:appearance).find_each do |horse|
      horse.generate_appearance
      appearances + 1
    end

    store_job_info(outcome: { genetics:, appearances: })
  end
end

