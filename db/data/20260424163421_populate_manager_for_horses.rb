# frozen_string_literal: true

class PopulateManagerForHorses < ActiveRecord::Migration[8.1]
  def up
    Horses::Horse.where.missing(:manager).find_each do |horse|
      manager = horse.current_lease.present? ? horse.current_lease.leaser : horse.owner
      horse.update(manager:)
    end
  end

  def down
    # rubocop:disable Rails/SkipsModelValidations
    Horses::Horse.where.associated(:manager).update_all(manager_id: nil)
    # rubocop:enable Rails/SkipsModelValidations
  end
end

