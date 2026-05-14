# frozen_string_literal: true

class PopulateBreedersCupNominations < ActiveRecord::Migration[8.1]
  def up
    Legacy::Nomination.find_each do |nomination|
      horse = Horses::Horse.where(status: %w[racehorse weanling yearling]).find_by(legacy_id: nomination.Horse)
      if horse
        nom = horse.breeders_cup_nomination || horse.build_breeders_cup_nomination
        nom.effective_year = (nomination.Year - 4) if nomination.Year.present?
        nom.save
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

