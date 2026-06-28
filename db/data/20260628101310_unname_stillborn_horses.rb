# frozen_string_literal: true

class UnnameStillbornHorses < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Horses::Horse.where("horses.date_of_birth = horses.date_of_death").where.not(name: nil).where.associated(:dam).includes(:dam).find_each do |horse|
      horse.update_columns(name: nil, slug: "stillborn-#{horse.date_of_birth.year}-#{horse.dam.slug}")
    end
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

