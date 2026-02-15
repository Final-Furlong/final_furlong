class Horses::UpdateBabiesJob < ApplicationJob
  queue_as :default

  def perform
    born = 0
    stillborn = 0
    Horses::Horse.where(status: "unborn").where(date_of_birth: ...Date.current).find_each do |horse|
      ActiveRecord::Base.transaction do
        if horse.date_of_birth == horse.date_of_death
          horse.update(status: "deceased")
          stillborn += 1
        else
          horse.update(status: "weanling")
          born += 1
        end
        horse.dam.due_dates.where(status: "bred").where(date: ...horse.date_of_birth).delete_all if horse.dam
      end
    end
    store_job_info(outcome: { born:, stillborn: })
  end
end

