class SetFarmFalseForFinalFurlongLocation < ActiveRecord::Migration[8.1]
  def up
    Location.where(name: 'Final Furlong').update_all(has_farm: false)
  end

  def down
    Location.where(name: 'Final Furlong').update_all(has_farm: true)
  end
end
