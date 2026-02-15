class Daily::UpdateBabiesJob < ApplicationJob
  queue_as :low_priority

  def perform
    born = 0
    stillborn = 0
    retired = 0
    died = 0
    Horses::Horse.where(status: "unborn").where("date_of_birth < ", Date.current).find_each do |horse|
      if horse.date_of_birth == horse.date_of_death
        stillborn += 1
        horse.update(status: "deceased")
      else
        born += 1
        horse.update(status: "weanling")
      end
    end
    store_job_info(outcome: { born:, stillborn:, retired:, died: })
  end
end

