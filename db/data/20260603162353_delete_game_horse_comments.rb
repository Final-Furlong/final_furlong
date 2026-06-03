# frozen_string_literal: true

class DeleteGameHorseComments < ActiveRecord::Migration[8.1]
  def up
    Horses::Comment.joins(:horse).merge(Horses::Horse.game_owned).delete_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

