# frozen_string_literal: true

class SetLeaserIdOnHorses < ActiveRecord::Migration[8.1]
  def up
    Horses::Lease.active.find_each do |lease|
      lease.horse.update(leaser_id: lease.leaser_id)
    end
  end

  def down
    Horses::Horse.where.not(leaser_id: nil).find_each do |horse|
      horse.update(leaser_id: nil)
    end
  end
end

